//
//  GITPackIndexWriterVersionOne.m
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackIndexWriterVersionOne.h"
#import "GITPackIndexWriter+Shared.h"


@interface GITPackIndexWriterVersionOne ()
@property (retain) NSMutableArray *objects;
@property (copy) NSData *packChecksum;
@end

@implementation GITPackIndexWriterVersionOne
@synthesize objects, packChecksum;

- (id)init {
    if ( ![super init] )
        return nil;

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

@end
