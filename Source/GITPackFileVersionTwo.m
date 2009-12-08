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
    return [self unpackObjectAtOffset:packOffset error:error];
}

- (GITPackFileObjectHeader *)unpackEntryHeaderAtOffset: (off_t *)offset {
    uint8_t buf;
    size_t shift = 4;
    GITPackFileObjectHeader header, *h = &header;

    header.offset = *offset;

    [self.data getBytes:&buf range:NSMakeRange(*offset++, 1)];

    header.size = buf & 0xf;
    header.type = (buf >> 4) & 0x7;

    while ( (buf & 0x80) != 0 ) {
        [self.data getBytes:&buf range:NSMakeRange(*offset++, 1)];
        header.size |= (buf & 0x7f) << shift;
        shift += 7;
    }

    off_t nextOffset = [self.index nextOffsetAfterOffset:*offset];
    if ( nextOffset == -1 )
        nextOffset = [self checksumRange].location;
    header.dataSize = nextOffset - *offset;

    return h;
}

- (GITPackObject *)unpackObjectAtOffset: (off_t)offset error:(NSError **)error {
    GITPackFileObjectHeader *header = [self unpackEntryHeaderAtOffset:&offset];

    NSData *packData;
    switch ( header->type ) {
        case GITObjectTypeCommit:
        case GITObjectTypeTree:
        case GITObjectTypeBlob:
        case GITObjectTypeTag:
            packData = [[self.data subdataWithRange:NSMakeRange(offset, header->dataSize)] zlibInflate];
            if ( [packData length] != header->size ) {
                GITError(error, GITPackFileErrorObjectSizeMismatch, NSLocalizedString(@"Object size mismatch", @"GITPackFileErrorObjectSizeMismatch"));
                return nil;
            }

            return [GITPackObject packObjectWithData:packData type:header->type];
            break;
        case GITPackFileDeltaTypeOfs:
        case GITPackFileDeltaTypeRefs:
            break;
        default:
            GITError(error, GITPackFileErrorObjectTypeUnknown, NSLocalizedString(@"Unknown packed object type", @"GITPackFileErrorObjectTypeUnknown"));
            break;
    }

    return nil;
}

- (NSRange)checksumRange {
    return NSMakeRange([self.data length] - GITObjectHashPackedLength, GITObjectHashPackedLength);
}

@end
