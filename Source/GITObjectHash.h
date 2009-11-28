//
//  GITObjectHash.h
//  Git.framework
//
//  Created by Geoff Garside on 08/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


extern const NSUInteger GITObjectHashSize;
extern const NSUInteger GITObjectHashPackedSize;

@interface GITObjectHash : NSObject {
    NSString *hash;
}

@property (copy) NSString *hash;

+ (NSString *)unpackedStringFromString: (NSString *)str;
+ (NSString *)packedStringFromString: (NSString *)str;
+ (NSData *)unpackedDataFromData: (NSData *)data;
+ (NSData *)packedDataFromData: (NSData *)data;
+ (NSData *)unpackedDataFromBytes: (uint8_t *)bytes length: (NSUInteger)length;
+ (NSData *)packedDataFromBytes: (uint8_t *)bytes length: (NSUInteger)length;

- (id)initWithData: (NSData *)hashData;
- (id)initWithString: (NSString *)hashString;
- (id)initWithObjectData: (NSData *)objectData;

@end
