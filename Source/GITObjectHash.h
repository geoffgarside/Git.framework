//
//  GITObjectHash.h
//  Git.framework
//
//  Created by Geoff Garside on 08/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


extern const NSUInteger GITObjectHashLength;
extern const NSUInteger GITObjectHashPackedLength;

/*!
 * The \c GITObjectHash class provides methods for packing and unpacking SHA1
 * hashes in both NSString and NSData forms. \c GITObjectHash objects provide
 * 
 */
@interface GITObjectHash : NSObject <NSCopying> {
    uint32_t raw[5];
}

/*!
 * Returns a string containing the unpacked SHA1 of the packed data.
 *
 * \param data Data containing the packed SHA1
 * \return NSString containing the unpacked SHA1
 */
+ (NSString *)unpackedStringFromData: (NSData *)data;

/*!
 * Returns a string containing the packed SHA1 of the unpacked data.
 *
 * \param data NSData containing the unpacked SHA1
 * \return NSString containing the packed SHA1
 * \sa unpackedStringFromString:
 */
+ (NSString *)packedStringFromData: (NSData *)data;

/*!
 * Returns data containing the unpacked SHA1 of the packed string.
 *
 * \param str String containing the packed SHA1
 * \return NSData containing the unpacked SHA1
 */
+ (NSData *)unpackedDataFromString: (NSString *)str;

/*!
 * Returns data containing the packed SHA1 of the unpacked string.
 *
 * \param str String containing the unpacked SHA1
 * \return NSData containing the packed SHA1
 */
+ (NSData *)packedDataFromString: (NSString *)str;

/*!
 * Returns an NSData object containing the unpacked SHA1 of the packed data.
 *
 * \param data NSData object containing packed SHA1
 * \return NSData object containing unpacked SHA1
 * \sa packedDataFromData:
 * \sa unpackedDataFromBytes:length:
 */
+ (NSData *)unpackedDataFromData: (NSData *)data;

/*!
 * Returns an NSData object containing the packed SHA1 of the unpacked data.
 *
 * \param data NSData object containing unpacked SHA1
 * \return NSData object containing packed SHA1
 * \sa unpackedDataFromData:
 * \sa packedDataFromBytes:length:
 */
+ (NSData *)packedDataFromData: (NSData *)data;

/*!
 * Returns an NSData object containing the unpacked SHA1 of the packed bytes.
 *
 * \param bytes Byte array containing the packed SHA1
 * \param length Size of the byte array
 * \return NSData object containing unpacked SHA1
 * \sa packedDataFromBytes:length:
 */
+ (NSData *)unpackedDataFromBytes: (uint8_t *)bytes length: (NSUInteger)length;

/*!
 * Returns an NSData object containing the packed SHA1 of the unpacked bytes.
 *
 * \param bytes Byte array containing the unpacked SHA1
 * \param length Size of the byte array
 * \return NSData object containing packed SHA1
 * \sa unpackedDataFromBytes:length:
 */
+ (NSData *)packedDataFromBytes: (uint8_t *)bytes length: (NSUInteger)length;

//! \name Creating and Initialising Object Hashes
/*!
 * Creates an autoreleased object hash with an NSData containing a packed or unpacked SHA1.
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
 * Returns an object hash with a string containing a packed or unpacked SHA1.
 *
 * \param str String containing a packed or unpacked SHA1
 * \return object hash with the string
 * \sa initWithData:
 */
- (id)initWithString: (NSString *)str;

/*!
 * Returns an object hash with an NSData containing ￼a packed or unpacked SHA1.
 *
 * \param data NSData containing a packed or unpacked SHA1
 * \return object hash with the NSData object
 * \sa initWithString:
 */
- (id)initWithData: (NSData *)data;

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
 * Returns the unpacked string of the object hash.
 *
 * \return unpacked string of the object hash
 * \sa packedString
 * \sa unpackedData
 * \sa packedData
 */
- (NSString *)unpackedString;

/*!
 * Returns the unpacked data of the object hash.
 *
 * \return unpacked data of the object hash
 * \sa packedData
 * \sa packedString
 * \sa unpackedString
 */
- (NSData *)unpackedData;

/*!
 * Returns the packed data of the object hash.
 *
 * \return packed data of the object hash
 * \sa unpackedData
 * \sa packedString
 * \sa unpackedString
 */
- (NSData *)packedData;

//! \name Testing Equality
/*!
 * Returns a Boolean value that indicates whether the receiver and a given object are equal.
 *
 * \param other The object to be compared to the receiver
 * \return YES if the receiver and other are equal, otherwise NO
 * \sa isEqualToData:
 * \sa isEqualToString:
 * \sa isEqualToObjectHash:
 */
- (BOOL)isEqual: (id)other;

/*!
 * Returns a Boolean value that indicates whether the receiver and a given data object are equal.
 *
 * \param data The data object with which to compare the receiver
 * \return YES if the receiver and data are equal, otherwise NO
 * \sa isEqual:
 * \sa isEqualToString:
 * \sa isEqualToObjectHash:
 */
- (BOOL)isEqualToData: (NSData *)data;

/*!
 * Returns a Boolean value that indicates whether the receiver and a given string are equal.
 *
 * \param str The string with which to compare the receiver
 * \return YES if the receiver and str are equal, otherwise NO
 * \sa isEqual:
 * \sa isEqualToData:
 * \sa isEqualToObjectHash:
 */
- (BOOL)isEqualToString: (NSString *)str;

/*!
 * Returns a Boolean value that indicates whether the receiver and a given ObjectHash are equal.
 *
 * \param hash The ObjectHash with which to compare the receiver
 * \return YES if the receiver and hash are equal, otherwise NO
 * \sa isEqual:
 * \sa isEqualToData:
 * \sa isEqualToString:
 */
- (BOOL)isEqualToObjectHash: (GITObjectHash *)hash;

@end
