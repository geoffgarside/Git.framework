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

@interface GITObjectHash ()
+ (uint8_t *)unpackedBytes: (uint8_t *)unpacked fromBytes: (uint8_t *)bytes length: (size_t)length;
+ (uint8_t *)packedBytes: (uint8_t *)packed fromBytes: (uint8_t *)bytes length: (size_t)length;

- (id)initWithUnpackedString: (NSString *)str;

- (id)initWithPackedData: (NSData *)data;
- (id)initWithUnpackedData: (NSData *)data;

- (id)initWithBytes: (uint8_t *)bytes length: (size_t)length;
- (id)initWithPackedBytes: (uint8_t *)bytes length: (size_t)length;
- (id)initWithUnpackedBytes: (uint8_t *)bytes length: (size_t)length;
@end

@implementation GITObjectHash

+ (NSString *)unpackedStringFromData: (NSData *)data {
    NSStringEncoding encoding = NSASCIIStringEncoding;
    if ( [data length] == GITObjectHashLength )
        encoding = NSUTF8StringEncoding;

    return [[[NSString alloc] initWithData:[self unpackedDataFromData:data]
                                  encoding:encoding] autorelease];
}
+ (NSString *)packedStringFromData: (NSData *)data {
    NSStringEncoding encoding = NSUTF8StringEncoding;
    if ( [data length] == GITObjectHashPackedLength )
        encoding = NSASCIIStringEncoding;

    return [[[NSString alloc] initWithData:[self packedDataFromData:data]
                                  encoding:encoding] autorelease];
}
+ (NSData *)unpackedDataFromString: (NSString *)str {
    if ( [str length] == GITObjectHashLength )
        return [str dataUsingEncoding:NSASCIIStringEncoding];
    return [self unpackedDataFromData:[str dataUsingEncoding:NSISOLatin1StringEncoding]];
}
+ (NSData *)packedDataFromString: (NSString *)str {
    if ( [str length] == GITObjectHashPackedLength )
        return [str dataUsingEncoding:NSISOLatin1StringEncoding];
    return [self packedDataFromData:[str dataUsingEncoding:NSASCIIStringEncoding]];
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

    NSMutableData *unpacked = [NSMutableData dataWithLength:GITObjectHashLength];
    [self unpackedBytes:[unpacked mutableBytes] fromBytes:bytes length:length];

    return [[unpacked copy] autorelease];
}
+ (NSData *)packedDataFromBytes: (uint8_t *)bytes length: (NSUInteger)length {
    if ( length == GITObjectHashPackedLength )
        return [NSData dataWithBytes:bytes length:length];

    NSMutableData *packed = [NSMutableData dataWithLength:GITObjectHashPackedLength];
    [self packedBytes:[packed mutableBytes] fromBytes:bytes length:length];

    return [[packed copy] autorelease];
}
+ (uint8_t *)unpackedBytes: (uint8_t *)unpacked fromBytes: (uint8_t *)bytes length: (size_t)length {
    if ( length == GITObjectHashLength ) {
        // if ( sizeof(unpacked) != GITObjectHashLength )
        //     return NULL;
        memcpy(unpacked, bytes, length);
        return unpacked;
    }

    if ( length != GITObjectHashPackedLength )// || sizeof(unpacked) != GITObjectHashLength )
        return NULL;

    int i;
    for ( i = 0; i < GITObjectHashPackedLength; i++ ) {
        *unpacked++ = hexchars[bytes[i] >> 4];
        *unpacked++ = hexchars[bytes[i] & 0xf];
    }

    return unpacked;
}
+ (uint8_t *)packedBytes: (uint8_t *)packed fromBytes: (uint8_t *)bytes length: (size_t)length {
    if ( length == GITObjectHashPackedLength ) {
        // if ( sizeof(packed) != GITObjectHashPackedLength )
        //     return NULL;
        memcpy(packed, bytes, length);
        return packed;
    }

    if ( length != GITObjectHashLength )//|| sizeof(packed) != GITObjectHashPackedLength )
        return NULL;

    int i, bits;
    for ( i = 0; i < GITObjectHashPackedLength; i++, bytes += 2 ) {
        bits = (from_hex[bytes[0]] << 4) | (from_hex[bytes[1]]);
        if ( bits < 0 )
            return NULL;
        packed[i] = (uint8_t)bits;
    }

    return packed;
}

//! \name Creating and Initialising Object Hashes
+ (GITObjectHash *)objectHashWithData: (NSData *)hashData {
    return [[[self alloc] initWithData:hashData] autorelease];
}
+ (GITObjectHash *)objectHashWithString: (NSString *)hashString {
    return [[[self alloc] initWithString:hashString] autorelease];
}
+ (GITObjectHash *)objectHashWithObjectData: (NSData *)objectData {
    return [[[self alloc] initWithObjectData:objectData] autorelease];
}

- (id)initWithString: (NSString *)str {
    return [self initWithPackedData:[[self class] packedDataFromString:str]];
}
- (id)initWithUnpackedString: (NSString *)str {
    return [self initWithPackedData:[[self class] packedDataFromString:str]];
}

- (id)initWithData: (NSData *)data {
    return [self initWithBytes:(uint8_t *)[data bytes] length:[data length]];
}
- (id)initWithPackedData: (NSData *)data {
    return [self initWithPackedBytes:(uint8_t *)[data bytes] length:[data length]];
}
- (id)initWithUnpackedData: (NSData *)data {
    return [self initWithUnpackedBytes:(uint8_t *)[data bytes] length:[data length]];
}

- (id)initWithBytes: (uint8_t *)bytes length: (size_t)length {
    if ( length == GITObjectHashPackedLength )
        return [self initWithPackedBytes:bytes length:length];
    return [self initWithUnpackedBytes:bytes length:length];
}
- (id)initWithPackedBytes: (uint8_t *)bytes length: (size_t)length {
    if ( length != GITObjectHashPackedLength || ![super init] )
        return nil;

    memset(raw, 0x0, sizeof(raw));
    if ( memcpy(raw, bytes, sizeof(raw)) < 0 )
        return nil;
    return self;
}
- (id)initWithUnpackedBytes: (uint8_t *)bytes length: (size_t)length {
    if ( length != GITObjectHashLength )
        return nil;

    uint8_t *packed = (uint8_t *) malloc ( sizeof(uint8_t) * GITObjectHashPackedLength );
    if ( [[self class] packedBytes:packed fromBytes:bytes length:length] == NULL ) {
        free ( packed );
        return nil;
    }

    id ret = [self initWithPackedBytes:packed length:GITObjectHashPackedLength];
    free ( packed );
    return ret;
}

- (id)initWithObjectData: (NSData *)objectData {
    return [self initWithData:[objectData sha1Digest]];
}

//! \name Copying
- (id)copyWithZone:(NSZone*)zone {
    return [[[self class] allocWithZone:zone] initWithPackedBytes:(uint8_t *)raw length:GITObjectHashPackedLength];
}

//! \name Getting Packed and Unpacked Forms
- (NSString *)unpackedString {
    return [[self class] unpackedStringFromData:[self unpackedData]];
}
- (NSData *)unpackedData {
    return [[self class] unpackedDataFromBytes:(uint8_t*)raw length:GITObjectHashPackedLength];
}
- (NSData *)packedData {
    return [[self class] packedDataFromBytes:(uint8_t*)raw length:GITObjectHashPackedLength];
}

//! \name Testing Equality
- (uint32_t *)raw {
    return raw;
}
- (NSUInteger)hash {
    NSUInteger hash = 5381, i = 0;

    for ( i = 0; i < 5; i++)
        hash = ((hash << 5) + hash) + raw[i];
    return hash;
}
- (BOOL)isEqual:(id)other {
    if ( !other ) return NO;                            // other is nil
    if ( other == self ) return YES;                    // pointers match?

    if ( [other isKindOfClass:[self class]] )           // Same class?
        return [self isEqualToObjectHash:other];
    if ( [other isKindOfClass:[NSString class]] )       // A string?
        return [self isEqualToString:other];
    if ( [other isKindOfClass:[NSData class]] )         // A data?
        return [self isEqualToData:other];

    return NO;                                          // Definitely not then
}
- (BOOL)isEqualToObjectHash: (GITObjectHash *)rhs {
    if ( !rhs )         return NO;
    if ( self == rhs )  return YES;
    if ( memcmp(raw, [rhs raw], 5) == 0 )
        return YES;
    return NO;
}
- (BOOL)isEqualToData: (NSData *)data {
    GITObjectHash *rhs = [[GITObjectHash alloc] initWithData:data];
    BOOL result = [self isEqualToObjectHash:rhs];
    [rhs release];
    return result;
}
- (BOOL)isEqualToString: (NSString *)str {
    GITObjectHash *rhs = [[GITObjectHash alloc] initWithString:str];
    BOOL result = [self isEqualToObjectHash:rhs];
    [rhs release];
    return result;
}
- (NSString *)description {
    return [self unpackedString];
}

@end
