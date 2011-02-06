//
//  GITPackFileWriterVersionTwo.m
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackFileWriterVersionTwo.h"
#import "GITPackFileVersionTwo.h"


@implementation GITPackFileWriterVersionTwo

- (id)init {
    if ( ![super init] )
        return nil;

    CC_SHA1_Init(&ctx);

    return self;
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

#pragma mark Helper Methods
- (NSData *)packedHeaderDataWithNumberOfObjects: (NSUInteger)numberOfObjects {
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:12];
    [data appendBytes:(void *)GITPackFileSignature length:4];
    [data appendBytes:(void *)GITPackFileVersionTwoVersionBytes length:4];

    uint32_t numberBytes = CFSwapInt32HostToBig(numberOfObjects);
    [data appendBytes:(void *)&numberBytes length:sizeof(uint32_t)];

    NSData *d = [[data copy] autorelease];
    [data release];
    return d;
}

@end
