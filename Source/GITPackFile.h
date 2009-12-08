//
//  GITPackFile.h
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GITPackIndex;

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
- (GITPackIndex *)index;

@end
