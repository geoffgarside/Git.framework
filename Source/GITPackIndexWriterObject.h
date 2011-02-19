//
//  GITPackIndexWriterObject.h
//  Git.framework
//
//  Created by Geoff Garside on 06/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITObjectHash;
@interface GITPackIndexWriterObject : NSObject {
    GITObjectHash *sha1;    //!< Object hash of the object to store in the index
    NSUInteger offset;      //!< Offset into the PACK file to find the object
    uint32_t crc32;         //!< CRC32 of the data of the object
}

@property (retain) GITObjectHash *sha1;
@property (assign) NSUInteger offset;
@property (assign,setter=setCRC32:) uint32_t crc32;

//! \name Creating and Initialising GITPackIndexWriterObject instances
/*!
 * Create an autoreleased index writer object with the specified \a sha1 and \a offset.
 *
 * \param sha1 Object hash name of the object
 * \param offset Offset of the object into the PACK file
 * \return index writer object
 */
+ (GITPackIndexWriterObject *)indexWriterObjectWithName: (GITObjectHash *)sha1 atOffset: (NSUInteger)offset;

/*!
 * Initialises an index writer with the specified \a sha1 and \a offset.
 *
 * \param sha1 Object hash name of the object
 * \param offset Offset of the object into the PACK file
 * \return index writer object
 */
- (id)initWithName: (GITObjectHash *)sha1 atOffset: (NSUInteger)offset;

//! \name Equality and Comparison
/*!
 * Returns a Boolean value that indicates whether the receiver and a given object are equal.
 *
 * \param other The object to be compared to the receiver
 * \return YES if the receiver and other are equal, otherwise NO
 * \sa isEqualToIndexWriterObject:
 * \sa isEqualToObjectHash:
 */
- (BOOL)isEqual: (id)other;

/*!
 * Returns a Boolean value that indicates whether the receiver and a given index write are equal.
 *
 * \param rhs The index writer with which to compare the receiver
 * \return YES if the receiver and rhs are equal, otherwise NO
 * \sa isEqual:
 * \sa isEqualToObjectHash:
 */
- (BOOL)isEqualToIndexWriterObject: (GITPackIndexWriterObject *)rhs;

/*!
 * Returns a Boolean value that indicates whether the receiver and a given ObjectHash refer to the same objects.
 *
 * \param rhs The ObjectHash with which to compare the receiver
 * \return YES if the receiver and rhs are equal, otherwise NO
 * \sa isEqual:
 * \sa isEqualToIndexWriterObject:
 */
- (BOOL)isEqualToObjectHash: (GITObjectHash *)rhs;

/*!
 * Returns an NSComparisonResult value that indicates whether the receiver is greater than,
 * equal to, or less than a given index writer object.
 *
 * \param obj The index writer object with which to compare the receiver. This value must
 * not be nil. If the value is nil, the behavior is undefined.
 * \return NSOrderedAscending if the value of \a obj is greater than the receiver’s,
 * NSOrderedSame if they’re equal, and NSOrderedDescending if the value of \a obj is less
 * than the receiver’s.
 */
- (NSComparisonResult)compare: (GITPackIndexWriterObject *)obj;

@end
