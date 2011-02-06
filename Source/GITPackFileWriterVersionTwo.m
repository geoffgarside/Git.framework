//
//  GITPackFileWriterVersionTwo.m
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackFileWriterVersionTwo.h"
#import "GITPackFileVersionTwo.h"
#import "GITObject.h"
#import "NSData+Compression.h"


@interface GITPackFileWriterVersionTwo ()
@property (readwrite,copy) NSArray *objects;
@end

@implementation GITPackFileWriterVersionTwo
@synthesize objects;

- (id)init {
    if ( ![super init] )
        return nil;

    state = 0;
    offset = 0;
    objectsWritten = 0;
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

- (NSData *)packedObjectDataWithType: (GITObjectType)type andData: (NSData *)objData {
    size_t shift = 4, size = [objData length];
    uint8_t byte = (type << 4) | ~0x7f;

    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:size + 1];

    byte |= size & 0x0f;
    while ( byte != 0 ) {
        [data appendBytes:(void *)&byte length:sizeof(byte)];
        byte = (size >> shift) & 0x7f;
        shift += 7;
    }

    [data appendData:objData];
    NSData *d = [[data copy] autorelease];
    [data release];
    return d;
}

#pragma mark Writer Methods
- (NSInteger)writeHeaderToStream: (NSOutputStream *)stream {
    offset += [self stream:stream writeData:[self packedHeaderDataWithNumberOfObjects:[objects count]]];
    return offset;
}

- (NSInteger)writeNextObjectToStream: (NSOutputStream *)stream {
    GITObject<GITObject> *obj = [objects objectAtIndex:objectsWritten++];
    NSData *zData  = [[obj rawContent] zlibDeflate];

    offset += [self stream:stream writeData:[self packedObjectDataWithType:obj.type andData:zData]];
    return offset;
}

#pragma mark NSRunLoop method
- (void)writeToStream: (NSOutputStream *)stream {
    switch ( state ) {
        case 0: // write header
            [self writeHeaderToStream:stream];
            state = 1;
            break;
        case 1: // write objects
            [self writeNextObjectToStream:stream];
            if ( objectsWritten >= [objects count] )
                state = 2;
            break;
        case 2: // write checksum
            [self writeChecksumToStream:stream];
            state = 3;
            break;
    }
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    switch ( eventCode ) {
        case NSStreamEventHasSpaceAvailable:
            [self writeToStream:(NSOutputStream *)stream];
            break;
    }
}

#pragma mark Polling Method
- (NSInteger)writeToStream: (NSOutputStream *)stream error: (NSError **)error {
    offset = 0;
    NSInteger prevOffset;
    if ( [stream hasSpaceAvailable] ) {
        prevOffset = offset;
        if ( [self writeHeaderToStream:stream] < prevOffset ) {  // if the write operation returned -1 we'll be smaller than the offset
            if ( error ) *error = [stream streamError];
            return -1;
        }

        while ( objectsWritten < [objects count] ) {
            prevOffset = offset;
            if ( [self writeNextObjectToStream:stream] < prevOffset ) {
                if ( error ) *error = [stream streamError];
                return -1;
            }
        }

        prevOffset = offset;
        if ( [self writeChecksumToStream:stream] < prevOffset ) {
            if ( error ) *error = [stream streamError];
            return -1;
        }
    }
}

@end
