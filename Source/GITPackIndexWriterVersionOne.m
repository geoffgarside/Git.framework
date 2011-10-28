//
//  GITPackIndexWriterVersionOne.m
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackIndexWriterVersionOne.h"
#import "GITPackIndexWriter+Shared.h"
#import "GITPackIndexWriterObject.h"
#import "GITObjectHash.h"


@interface GITPackIndexWriterVersionOne ()
@property (retain) NSMutableArray *objects;
@property (copy) NSData *packChecksum;
@end

@implementation GITPackIndexWriterVersionOne
@synthesize objects, packChecksum;

- (id)init {
    if ( ![super init] )
        return nil;

    state = 0;
    objectsWritten = 0;
    CC_SHA1_Init(&ctx);
    memset(fanoutTable, 0, sizeof(fanoutTable));
    self.objects = [NSMutableArray array];

    return self;
}

- (void)dealloc {
    self.objects = nil;
    self.packChecksum = nil;
    [super dealloc];
}

- (uint32_t *)fanoutTable {
    return fanoutTable;
}

#pragma mark Checksumming writer methods
- (NSInteger)stream: (NSOutputStream *)stream write: (const uint8_t *)buffer maxLength: (NSUInteger)length {
    CC_SHA1_Update(&ctx, buffer, length);
    return [stream write:buffer maxLength:length];
}
- (NSInteger)stream: (NSOutputStream *)stream writeData: (NSData *)data {
    return [self stream:stream write:(uint8_t *)[data bytes] maxLength:[data length]];
}
- (NSInteger)writeChecksumToStream: (NSOutputStream *)stream {
    unsigned char checksum[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(checksum, &ctx);

    return [stream write:(uint8_t *)checksum maxLength:CC_SHA1_DIGEST_LENGTH];
}

#pragma mark Object Addition Methods
- (void)addObjectWithName: (GITObjectHash *)sha1 andData: (NSData *)data atOffset: (NSUInteger)offset {
    if ( offset > UINT32_MAX ) {
        return; // really need to put some error somewhere, or else convert
    }           // us to a VersionTwo index file to save the user some trouble.

    [self addObjectHashToFanoutTable:sha1];

    GITPackIndexWriterObject *obj = [GITPackIndexWriterObject indexWriterObjectWithName:sha1 atOffset:offset];
    [objects addObject:obj];
    (void)data;
}
- (void)addPackChecksum: (NSData *)packChecksumData {
    self.packChecksum = packChecksumData;
}

- (void)prepareForWriting {
    [self.objects sortUsingSelector:@selector(compare:)];
}

#pragma mark Writer Methods
- (NSInteger)writeObjectEntryToStream: (NSOutputStream *)stream {
    GITPackIndexWriterObject *obj = [objects objectAtIndex:objectsWritten++];

    NSInteger written = 0;
    uint32_t offset = CFSwapInt32HostToBig((uint32_t)[obj offset]);
    written += [self stream:stream write:(uint8_t *)&offset maxLength:sizeof(offset)];
    written += [self stream:stream writeData:[[obj sha1] packedData]];
    return written;
}
- (NSInteger)writePackChecksumToStream: (NSOutputStream *)stream {
    return [self stream:stream writeData:packChecksum];
}
- (NSInteger)writeToStream: (NSOutputStream *)stream {
    NSInteger written = 0;
    switch ( state ) {
        case 0: // write fanout table
            written = [self writeFanoutTableToStream:stream];
            state = 1;
            break;
        case 1: // write object entries
            written = [self writeObjectEntryToStream:stream];
            if ( objectsWritten >= [objects count] )
                state = 2;
            break;
        case 2: // write pack checksum
            written = [self writePackChecksumToStream:stream];
            state = 3;
            break;
        case 3: // write checksum
            written = [self writeChecksumToStream:stream];
            state = 4;
            break;
        case 4:
            [stream close];
            break;
    }
    return written;
}

@end
