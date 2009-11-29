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

/*!
 * The \c GITObjectHash class provides methods for packing and unpacking SHA1
 * hashes in both NSString and NSData forms. \c GITObjectHash objects provide
 * 
 */
@interface GITObjectHash : NSObject {
    NSString *hash;
}

@property (copy) NSString *hash;

//! \name Packing and Unpacking SHA1 Hashes
/*!
 * Returns a string containing the unpacked SHA1 of the packed string￼.
 *
 * \param str NSString containing the packed SHA1
 * \return NSString containing the unpacked SHA1
 * \sa packedStringFromString:
 */
+ (NSString *)unpackedStringFromString: (NSString *)str;

/*!
 * Returns a string containing the packed SHA1 of the unpacked string￼.
 *
 * \param str NSString containing the unpacked SHA1
 * \return NSString containing the packed SHA1
 * \sa unpackedStringFromString:
 */
+ (NSString *)packedStringFromString: (NSString *)str;

/*!
 * Returns an NSData object containing the unpacked SHA1 of the packed data￼.
 *
 * \param data NSData object containing packed SHA1
 * \return NSData object containing unpacked SHA1
 * \sa packedDataFromData:
 * \sa unpackedDataFromBytes:length:
 */
+ (NSData *)unpackedDataFromData: (NSData *)data;

/*!
 * Returns an NSData object containing the packed SHA1 of the unpacked data￼.
 *
 * \param data NSData object containing unpacked SHA1
 * \return NSData object containing packed SHA1
 * \sa unpackedDataFromData:
 * \sa packedDataFromBytes:length:
 */
+ (NSData *)packedDataFromData: (NSData *)data;

/*!
 * Returns an NSData object containing the unpacked SHA1 of the packed bytes￼.
 *
 * \param bytes Byte array containing the packed SHA1
 * \param length Size of the byte array
 * \return NSData object containing unpacked SHA1
 * \sa packedDataFromBytes:length:
 */
+ (NSData *)unpackedDataFromBytes: (uint8_t *)bytes length: (NSUInteger)length;

/*!
 * Returns an NSData object containing the packed SHA1 of the unpacked bytes￼.
 *
 * \param bytes Byte array containing the unpacked SHA1
 * \param length Size of the byte array
 * \return NSData object containing packed SHA1
 * \sa unpackedDataFromBytes:length:
 */
+ (NSData *)packedDataFromBytes: (uint8_t *)bytes length: (NSUInteger)length;

//! \name Creating and Initialising Object Hashes
/*!
 * Creates an autoreleased object hash with an NSData containing a packed or unpacked SHA1￼.
 *
 * \param hashData NSData containing a packed or unpacked SHA1
 * \return object hash with the NSData object
 * \sa initWithData:
 */
+ (GITObjectHash *)objectHashWithData: (NSData *)hashData;

/*!
 * Returns an object hash with a string containing a packed or unpacked SHA1.
 *
 * \param hashString String containing a packed or unpacked SHA1
 * \return object hash with the string
 * \sa initWithString:
 */
+ (GITObjectHash *)objectHashWithString: (NSString *)hashString;

/*!
 * Returns an object hash from the SHA1 Hash of the ￼provided data object.
 *
 * \param objectData Object data to create GITObjectHash of
 * \return object hash of the data object
 * \sa initWithObjectData:
 */
+ (GITObjectHash *)objectHashWithObjectData: (NSData *)objectData;

/*!
 * Returns an object hash with an NSData containing ￼a packed or unpacked SHA1.
 *
 * \param hashData NSData containing a packed or unpacked SHA1
 * \return object hash with the NSData object
 * \sa initWithString:
 */
- (id)initWithData: (NSData *)hashData;

/*!
 * Returns an object hash with a string containing a packed or unpacked SHA1.
 *
 * \param hashString String containing a packed or unpacked SHA1
 * \return object hash with the string
 * \sa initWithData:
 */
- (id)initWithString: (NSString *)hashString;

/*!
 * Returns an object hash from the SHA1 Hash of the ￼provided data object.
 *
 * \param objectData Object data to create GITObjectHash of
 * \return object hash of the data object
 * \sa initWithString:
 * \sa initWithData:
 */
- (id)initWithObjectData: (NSData *)objectData;

//! \name Getting Packed and Unpacked Forms
/*!
 * Returns the unpacked string of the object hash￼.
 *
 * \return unpacked string of the object hash
 * \sa packedString
 * \sa unpackedData
 * \sa packedData
 */
- (NSString *)unpackedString;

/*!
 * Returns the packed string of the object hash￼.
 *
 * \return packed string of the object hash
 * \sa unpackedString
 * \sa unpackedData
 * \sa packedData
 */
- (NSString *)packedString;

/*!
 * Returns the unpacked data of the object hash￼.
 *
 * \return unpacked data of the object hash
 * \sa packedData
 * \sa packedString
 * \sa unpackedString
 */
- (NSData *)unpackedData;

/*!
 * Returns the packed data of the object hash￼.
 *
 * \return packed data of the object hash
 * \sa unpackedData
 * \sa packedString
 * \sa unpackedString
 */
- (NSData *)packedData;

@end
