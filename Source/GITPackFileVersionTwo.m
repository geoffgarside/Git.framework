//
//  GITPackFileVersionTwo.m
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackFileVersionTwo.h"
#import "GITPackIndex.h"
#import "GITError.h"
#import "GITPackObject.h"
#import "GITObjectHash.h"
#import "GITObject.h"
#import "NSData+Compression.h"


@implementation GITPackFileVersionTwo

@synthesize data, index;

- (NSUInteger)version {
    return 2;
}

- (id)initWithData: (NSData *)packData indexPath:(NSString *)indexPath error:(NSError **)error {
    if ( ![super init] )
        return nil;

    self.data = packData;
    self.index = [GITPackIndex packIndexWithPath:indexPath error:error];

    return self;
}

- (void)dealloc {
    self.data = nil;
    self.index = nil;

    [super dealloc];
}

- (GITPackObject *)unpackObjectWithSha1: (GITObjectHash *)objectHash error: (NSError **)error {
    if ( !self.index ) {
        GITError(error, GITPackFileErrorIndexMissing, NSLocalizedString(@"Missing IDX for this PACK file", @"GITPackFileErrorIndexMissing"));
        return nil;
    }

    off_t packOffset = [self.index packOffsetForSha1:objectHash error:error];
    if ( packOffset == NSNotFound )
        return nil;
    return [self unpackObjectAtOffset:packOffset sha1:objectHash error:error];
}

- (GITPackFileObjectHeader *)unpackEntryHeaderAtOffset: (off_t *)offset intoHeader: (GITPackFileObjectHeader *)header {
    uint8_t buf;
    size_t shift = 4;

    memset(header, 0x0, sizeof(GITPackFileObjectHeader));
    header->offset = *offset;

    [self.data getBytes:&buf range:NSMakeRange((*offset)++, 1)];

    header->size = buf & 0xf;
    header->type = (buf >> 4) & 0x7;

    while ( (buf & 0x80) != 0 ) {
        [self.data getBytes:&buf range:NSMakeRange((*offset)++, 1)];
        header->size |= (buf & 0x7f) << shift;
        shift += 7;
    }

    return header;
}

- (GITPackObject *)unpackObjectAtOffset: (off_t)offset sha1: (GITObjectHash *)objectHash error:(NSError **)error {
    GITPackFileObjectHeader header;
    [self unpackEntryHeaderAtOffset:&offset intoHeader:&header];

    NSMutableData *packData;
    switch ( header.type ) {
        case GITObjectTypeCommit:
        case GITObjectTypeTree:
        case GITObjectTypeBlob:
        case GITObjectTypeTag:
            packData = [NSMutableData dataWithLength:header.size];

            if ( [self.data zlibInflateInto:packData offset:offset] != header.size ) {
                GITError(error, GITPackFileErrorObjectSizeMismatch, NSLocalizedString(@"Object size mismatch", @"GITPackFileErrorObjectSizeMismatch"));
                return nil;
            }

            return [GITPackObject packObjectWithData:packData sha1:objectHash type:header.type];
            break;
        case GITPackFileDeltaTypeOfs:
        case GITPackFileDeltaTypeRefs:
            return [self unpackDeltaPackedObjectAtOffset:offset objectHeader:&header sha1:objectHash error:error];
            break;
        default:
            GITError(error, GITPackFileErrorObjectTypeUnknown, NSLocalizedString(@"Unknown packed object type", @"GITPackFileErrorObjectTypeUnknown"));
            break;
    }

    return nil;
}

- (GITPackObject *)unpackDeltaPackedObjectAtOffset: (off_t)offset objectHeader: (GITPackFileObjectHeader *)header sha1: (GITObjectHash *)objectHash error: (NSError **)error {
    NSData *packedData = [self.data subdataWithRange:NSMakeRange(offset, GITObjectHashPackedLength)];
    off_t baseOffset = 0;

    if ( header->type == GITPackFileDeltaTypeRefs ) {
        offset += GITObjectHashPackedLength;        // Annoyingly this GITObjectHash will just be packed again...
        baseOffset = [self.index packOffsetForSha1:[GITObjectHash objectHashWithData:packedData] error:error];
    } else if ( header->type == GITPackFileDeltaTypeOfs ) {
        NSUInteger used = 0;
        const uint8_t *bytes = [packedData bytes];
        uint8_t c = bytes[used++];
        baseOffset = c & 0x7f;
        while ( (c & 0x80) != 0 ) {
            baseOffset++;
            c = bytes[used++];
            baseOffset <<= 7;
            baseOffset |= c & 0x7f;
        }

        baseOffset = header->offset - baseOffset;
        offset += used;
    }

    GITPackObject *packObject = [self unpackObjectAtOffset:baseOffset sha1:objectHash error:error];
    if ( !packObject ) {
        GITError(error, GITPackErrorObjectNotFound, NSLocalizedString(@"Base object for PACK delta not found", @"GITPackErrorObjectNotFound"));
        return nil;
    }

    NSMutableData *deltaData = [NSMutableData dataWithLength:header->size];
    if ( [self.data zlibInflateInto:deltaData offset:offset] < 0 ) {
        GITError(error, GITPackFileErrorInflationFailed, NSLocalizedString(@"Inflation of packed object failed", @"GITPackFileErrorInflationFailed"));
        return nil;
    }
    return [packObject packObjectByDeltaPatchingWithData:deltaData];
}

- (NSRange)checksumRange {
    return NSMakeRange([self.data length] - GITObjectHashPackedLength, GITObjectHashPackedLength);
}

@end
