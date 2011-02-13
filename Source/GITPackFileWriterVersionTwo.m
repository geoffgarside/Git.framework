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
#import "GITPackIndexWriter.h"
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

- (void)dealloc {
    self.objects = nil;
    [super dealloc];
}

- (NSString *)name {
    CC_SHA1_CTX nameCtx;
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];

    NSMutableArray *shas = [[NSMutableArray alloc] initWithCapacity:[objects count]];
    if ( GITObject<GITObject> *obj in self.objects )
        [shas addObject:[obj sha1]];
    NSArray *sortedShas  = [shas sortedArrayUsingSelector:@selector(compare:)];
    [shas release];

    CC_SHA1_INIT(&nameCtx);
    for ( GITObjectHash *sha1 in sortedShas ) {
        NSData *d = [sha1 packedData];
        CC_SHA1_Update(&nameCtx, [d bytes], [d length]);
    }
    CC_SHA1_Final(digest, &nameCtx);

    NSData *data = [[NSData alloc] initWithBytesNoCopy:digest length:CC_SHA1_DIGEST_LENGTH freeWhenDone:NO];
    NSString *name = [GITObjectHash unpackedStringFromData:data];
    [data release];
    return name;
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

    if ( [indexWriter respondsToSelector:@selector(addPackChecksum:)] ) {
        NSData *checksumData = [[NSData alloc] initWithBytes:checksum length:CC_SHA1_DIGEST_LENGTH];
        [indexWriter addPackChecksum:checksumData];
        [checksumData release];
    }

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
    NSInteger written = [self stream:stream writeData:[self packedHeaderDataWithNumberOfObjects:[objects count]]];
    offset += written;
    return written;
}
- (NSInteger)writeNextObjectToStream: (NSOutputStream *)stream {
    GITObject<GITObject> *obj = [objects objectAtIndex:objectsWritten++];
    NSData *zData  = [[obj rawContent] zlibDeflate];

    if ( [indexWriter respondsToSelector:@selector(addObjectWithName:andData:atOffset:)] )
        [indexWriter addObjectWithName:obj.sha1 andData:zData atOffset:offset];

    NSInteger written = [self stream:stream writeData:[self packedObjectDataWithType:obj.type andData:zData]];
    offset += written;
    return written;
}
- (NSInteger)writeToStream: (NSOutputStream *)stream {
    NSInteger written = 0;
    switch ( state ) {
        case 0: // write header
            written = [self writeHeaderToStream:stream];
            state = 1;
            break;
        case 1: // write objects
            written = [self writeNextObjectToStream:stream];
            if ( objectsWritten >= [objects count] )
                state = 2;
            break;
        case 2: // write checksum
            written = [self writeChecksumToStream:stream];
            state = 3;
            break;
        case 3:
            // TODO: Kick off the indexWriters write method
            [stream close];
            break;
    }
    return written;
}

@end
