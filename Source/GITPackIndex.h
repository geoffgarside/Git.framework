//
//  GITPackIndex.h
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * Structure representing the information in the Index Fanout Table
 */
typedef struct {
    NSUInteger numberOfPriorEntries;
    NSUInteger numberOfEntries;
} GITFanoutEntry;

/*!
 * Creates a new GITFanoutEntry from the specified values￼.
 *
 * \return A GITFanoutEntry with numberOfPriorEntries \e prior and numberOfEntries \e entries
 * \sa GITFanoutEntry
 */
GITFanoutEntry GITMakeFanoutEntry(NSUInteger prior, NSUInteger entries);

@class GITObjectHash;

/*!
 * The \c GITPackIndex class cluster provides access to the PACK index
 * files for looking up SHA1 object hashes when extracting GIT Objects
 * from PACK files.
 *
 * Current features of the PACK Index object include;
 *
 * \li Parsing of the Fan Out Table
 * \li Locating SHA1 entries in the Index
 *
 * \internal
 * Planned features:
 * \li Extracting and Verifying Checksums
 *
 * \section How it works
 * - fanout table (-fanoutTable:)
 *   - 256 entries
 *   - entry corresponds to the first byte of a packed SHA
 *   - value is the number of SHA in INDEX with first byte <= entry
 * - indexOfSHA
 *   - returns the index (row) in the Main Index Table where the SHA information can be read
 * - packOffsetForSha1:error:
 *   - returns the offset of the SHA object within the associated PACK file
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
 * Returns the contents of the receivers fanout table.
 *
 * \attention Implementers
 * If you are using Objective-C 2.0 properties then \@synthesize'ing fanoutTable
 * will overwrite this method with the property version.
 *
 * \return contents of the receivers fanout table or nil if an error occurred
 * \sa offsets:
 */
- (NSArray *)fanoutTable;

/*!
 * Returns the contents of the receivers fanout table.
 *
 * The fanout table consists of one entry per byte value (0-255). The entry value
 * indicates the number of SHA1 hashes stored in the Index file which have a first
 * byte which is less than or equal to the entry index. The contents of the fanout
 * table are used to determine a bounding box of index positions within the main
 * index table in which a SHA1 index entry will exist.
 *
 * If the offset fanout table is corrupted a GITPackIndexErrorCorrupt NSError will
 * be returned through the passed \a error.
 *
 * \param error NSError describing the error which occurred
 * \return contents of the receivers fanout table or nil if an error occurred
 * \sa fanoutTable
 */
- (NSArray *)fanoutTable: (NSError **)error;

/*!
 * Returns the number of objects stored in the PACK file.
 *
 * \return number of objects stored in the PACK file
 * \sa fanoutTable:
 */
- (NSUInteger)numberOfObjects;

/*!
 * Returns the index position of the entry for the object has in the main index table.
 *
 * Uses a binary search of the main index table bounded by the range given by the
 * fanout table.
 *
 * \param objectHash Object hash to find the index of
 * \return index position of the entry in the main index table
 */
- (NSUInteger)indexOfSha1: (GITObjectHash *)objectHash;

/*!
 * Returns the offset from the entry in the index table at the specified \a idx.
 *
 * \param idx Index position of the offset to retrieve
 * \return the offset from the entry at the specified index position
 * \sa packOffsetForSha1:error:
 * \sa packOffsetForSha1:
 * \internal
 * In GITPackIndexVersionOne this method uses the \c indexEntryAtIndex: method to determine
 * and retrieve the offset value which corresponds to the index of the Sha entry in the index
 * table.
 *
 */
- (off_t)packOffsetAtIndex: (NSUInteger)idx;

/*!
 * Returns the offset in the PACK file where the object data can be retrieved.
 *
 * \param objectHash Object hash to find the PACK offset of
 * \return the PACK offset where data of the object can be retrieved or NSNotFound on error
 * \sa packOffsetForSha1:error:
 */
- (off_t)packOffsetForSha1: (GITObjectHash *)objectHash;

/*!
 * Returns the offset in the PACK file where the object data can be retrieved.
 *
 * If the object cannot be found in the Index file then a \c GITPackErrorObjectNotFound error
 * is returned via the \a error argument.
 *
 * \param objectHash Object hash to find the PACK offset of
 * \param error NSError describing the error which occurred
 * \return the PACK offset where data of the object can be retrieved or NSNotFound on error
 * \sa packOffsetForSha1:
 */
- (off_t)packOffsetForSha1: (GITObjectHash *)objectHash error: (NSError **)error;

//! \name Internal Methods
/*!
 * Returns a fanout entry for SHA starting with the specified byte.
 *
 * \param byte The byte corresponding to the fanout entry
 * \return A fanout entry for the SHA starting with the specified byte
 * \sa fanoutTable:
 * \sa fanoutTable
 */
- (GITFanoutEntry)fanoutEntryForShasStartingWithByte: (uint8_t)byte;

@end
