//
//  GITPackIndex.h
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITObjectHash;

/*!
 * The \c GITPackIndex class cluster provides access to the PACK index
 * files for looking up SHA1 object hashes when extracting GIT Objects
 * from PACK files.
 */
@interface GITPackIndex : NSObject {

}

//! \name Creating and Initialising PACK Index Files
/*!
 * Creates an autoreleased Index file object with the specified path￼.
 *
 * \param indexPath Path to the index file
 * \param error NSError describing the error that occurred
 * \return autoreleased index file object or nil on error
 * \sa initWithPath:error:
 * \sa initWithData:error:
 */
+ (id)packIndexWithPath: (NSString *)indexPath error: (NSError **)error;

/*!
 * Initialise the Index file with the provided path￼.
 *
 * \param indexPath Path to the index file
 * \param error NSError describing the error that occurred
 * \return index file object or nil on error
 * \sa initWithData:error:
 */
- (id)initWithPath: (NSString *)indexPath error: (NSError **)error;

/*!
 * Initialise the Index file with the provided data￼.
 *
 * \param indexData NSData object of the index file data
 * \param error NSError describing the error that occurred
 * \return index file object or nil on error
 */
- (id)initWithData: (NSData *)indexData error: (NSError **)error;

//! \name Index File Information
/*!
 * Returns the version of the index file￼.
 *
 * \return Integer version of the index file
 */
- (NSUInteger)version;

/*!
 * Returns the contents of the receivers fanout table￼.
 *
 * \attention Implementers
 * If you are using Objective-C 2.0 properties then @synthesize'ing fanoutTable
 * will overwrite this method with the property version.
 *
 * \return contents of the receivers fanout table or nil if an error occurred
 * \sa offsets:
 */
- (NSArray *)fanoutTable;

/*!
 * Returns the contents of the receivers fanout table￼.
 *
 * \param error NSError describing the error which occurred
 * \return contents of the receivers fanout table or nil if an error occurred
 * \sa fanoutTable
 */
- (NSArray *)fanoutTable: (NSError **)error;

- (NSUInteger)indexOfSha1: (GITObjectHash *)objectHash;

//! \name Internal Methods
- (NSRange)rangeOfShasStartingWithByte:(uint8_t)byte;

@end
