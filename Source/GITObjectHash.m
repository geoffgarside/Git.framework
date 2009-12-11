//
//  GITObjectHash.m
//  Git.framework
//
//  Created by Geoff Garside on 08/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITObjectHash.h"
#import "NSData+SHA1.h"


const NSUInteger GITObjectHashLength = 40;
const NSUInteger GITObjectHashPackedLength = 20;

static const char hexchars[] = "0123456789abcdef";
static signed char from_hex[256] = {
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* 00 */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* 10 */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* 20 */
     0,  1,  2,  3,  4,  5,  6,  7,  8,  9, -1, -1, -1, -1, -1, -1, /* 30 */
    -1, 10, 11, 12, 13, 14, 15, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* 40 */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* 50 */
    -1, 10, 11, 12, 13, 14, 15, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* 60 */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* 70 */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* 80 */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* 90 */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* a0 */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* b0 */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* c0 */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* d0 */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* e0 */
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, /* f0 */
};

@implementation GITObjectHash

@synthesize hash;

+ (NSString *)unpackedStringFromString: (NSString *)str {
    if ( [str length] == GITObjectHashLength )
        return str;

/*  For some reason this doesn't work in our tests, it looks like an encoding issue */
/*  NSData *packedData = [str dataUsingEncoding:NSUTF8StringEncoding];  // NSISOLatin1StringEncoding seems to work...
    return [[[NSString alloc] initWithData:[self unpackedDataFromData:packedData]
                                  encoding:NSUTF8StringEncoding] autorelease];*/

    NSUInteger i;
    uint8_t packedBits;
    NSMutableString *unpacked = [NSMutableString stringWithCapacity:GITObjectHashLength];

    for ( i = 0; i < GITObjectHashPackedLength; i++ ) {
        packedBits = [str characterAtIndex:i];
        [unpacked appendFormat:@"%c", hexchars[packedBits >> 4]];
        [unpacked appendFormat:@"%c", hexchars[packedBits & 0xf]];
    }

    return [[unpacked copy] autorelease];
}

+ (NSString *)packedStringFromString: (NSString *)str {
    if ( [str length] == GITObjectHashPackedLength )
        return str;

    NSData *unpackedData = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [[[NSString alloc] initWithData:[self packedDataFromData:unpackedData]
                                  encoding:NSASCIIStringEncoding] autorelease];
}

+ (NSData *)unpackedDataFromData: (NSData *)data {
    if ( [data length] == GITObjectHashLength )
        return data;
    return [self unpackedDataFromBytes:(uint8_t *)[data bytes] length:[data length]];
}

+ (NSData *)packedDataFromData: (NSData *)data {
    if ( [data length] == GITObjectHashPackedLength )
        return data;
    return [self packedDataFromBytes:(uint8_t *)[data bytes] length:[data length]];
}

+ (NSData *)unpackedDataFromBytes: (uint8_t *)bytes length: (NSUInteger)length {
    if ( length == GITObjectHashLength )
        return [NSData dataWithBytes:bytes length:length];

    NSUInteger i;
    NSMutableData *unpacked = [NSMutableData dataWithLength:GITObjectHashLength];
    uint8_t *unpackedBytes = [unpacked mutableBytes];
    for ( i = 0; i < length; i++ ) {
        *unpackedBytes++ = hexchars[bytes[i] >> 4];
        *unpackedBytes++ = hexchars[bytes[i] & 0xf];
    }

    return [[unpacked copy] autorelease];
}

+ (NSData *)packedDataFromBytes: (uint8_t *)bytes length: (NSUInteger)length {
    if ( length == GITObjectHashPackedLength )
        return [NSData dataWithBytes:bytes length:length];

    NSUInteger i, bits;
    NSMutableData *packed = [NSMutableData dataWithLength:GITObjectHashPackedLength];
    uint8_t *packedBytes = [packed mutableBytes];

    /* We assume GITObjectHashPackedLength * 2 == length here */
    for ( i = 0; i < GITObjectHashPackedLength; i++ ) {
        bits = (from_hex[bytes[0]] << 4) | (from_hex[bytes[1]]);
        if ( bits < 0 ) return nil;
        bytes += 2;
        packedBytes[i] = (uint8_t)bits;
    }

    return [[packed copy] autorelease];
}

+ (NSString *)unpackedStringFromData: (NSData *)data {
    if ( [data length] == GITObjectHashLength )
        return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];

    return [[[NSString alloc] initWithData:[self unpackedDataFromData:data]
                                  encoding:NSUTF8StringEncoding] autorelease];
}

+ (GITObjectHash *)objectHashWithData: (NSData *)hashData {
    return [[[self alloc] initWithData:hashData] autorelease];
}

+ (GITObjectHash *)objectHashWithString: (NSString *)hashString {
    return [[[self alloc] initWithString:hashString] autorelease];
}

+ (GITObjectHash *)objectHashWithObjectData: (NSData *)objectData {
    return [[[self alloc] initWithObjectData:objectData] autorelease];
}

- (id)initWithData: (NSData *)hashData {
    NSString *hashString = [[[NSString alloc] initWithData:hashData encoding:NSUTF8StringEncoding] autorelease];
    return [self initWithString:hashString];
}

- (id)initWithString: (NSString *)hashString {
    if ( ![super init] )
        return nil;

    self.hash = hashString;

    return self;
}

- (id)initWithObjectData: (NSData *)objectData {
    return [self initWithString:[objectData sha1DigestString]];
}

- (NSString *)unpackedString {
    if ( [self.hash length] == GITObjectHashPackedLength )
        return [[self class] unpackedStringFromString:self.hash];
    return self.hash;
}

- (NSString *)packedString {
    if ( [self.hash length] == GITObjectHashLength )
        return [[self class] packedStringFromString:self.hash];
    return self.hash;
}

- (NSData *)hashData {
    return [self.hash dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)unpackedData {
    if ( [self.hash length] == GITObjectHashPackedLength )
        return [[self class] unpackedDataFromData:[self hashData]];
    return [self hashData];
}

- (NSData *)packedData {
    if ( [self.hash length] == GITObjectHashLength )
        return [[self class] packedDataFromData:[self hashData]];
    return [self hashData];
}

@end
