//
//  GITPackFile.h
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITPackIndex, GITPackObject, GITObjectHash;

/*!
 * GITPackFile is a class which provides access to individual
 * PACK files within a git repository.
 *
 * A PACK file is an archive format used by git primarily for
 * network transmission of repository objects. Once transmitted
 * the received PACK files are then used for access to the stored
 * objects.
 */
@interface GITPackFile : NSObject {

}

//! \name Creating and Initialising PACK Files
/*!
 * Create an autoreleased PACK file with the specified path.
 *
 * \param packPath Path to the PACK file
 * \param error NSError describing the error that occurred
 * \return PACK File object or nil if an error occurred
 * \sa initWithPath:error:
 */
+ (id)packWithPath: (NSString *)packPath error: (NSError **)error;

/*!
 * Initialises a PACK file with the specified path.
 *
 * \param packPath Path to the PACK file
 * \param error NSError describing the error that occurred
 * \return PACK File object or nil if an error occurred
 * \sa initWithData:indexPath:error:
 */
- (id)initWithPath: (NSString *)packPath error: (NSError **)error;

/*!
 * Initialises a PACK file with the specified data and path to index file.
 *
 * \param packData NSData object of the PACK file data
 * \param indexPath Path to the PACK files Index file
 * \param error NSError describing the error that occurred
 * \return PACK file object or nil if an error occurred
 */
- (id)initWithData: (NSData *)packData indexPath: (NSString *)indexPath error: (NSError **)error;

//! \name PACK File Information
/*!
 * Returns the PACK file version.
 *
 * \return Integer version of the PACK file
 */
- (NSUInteger)version;

/*!
 * Returns the index of the receiver
 *
 * \return index of the receiver
 */
- (GITPackIndex *)index;

/*!
 * Returns the number of objects stored in the receiver
 *
 * \return number of objects in the receiver
 */
- (NSUInteger)numberOfObjects;

//! \name Object Extraction
/*!
 * Returns a pack object identified by \a objectHash.
 *
 * The pack object consists of the data required to create a proper git object.
 *
 * \param objectHash Hash identifying the object data to retrieve
 * \param error NSError describing the error which occurred
 * \return pack object for the specified \a objectHash or nil if an error occurred
 */
- (GITPackObject *)unpackObjectWithSha1: (GITObjectHash *)objectHash error: (NSError **)error;

@end
