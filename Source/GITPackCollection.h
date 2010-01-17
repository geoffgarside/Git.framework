//
//  GITPackCollection.h
//  Git.framework
//
//  Created by Geoff Garside on 16/01/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITPackFile, GITPackObject, GITObjectHash;

/*!
 * This class implements a proxy for unpacking objects from a collection of
 * GITPackFile instances.
 *
 * A git repository might contain a number of PACK files, each of these are
 * independent of each other and contain different sets of data. To aid extraction
 * of objects from the collection of PACK files this class provides a means
 * to iterate over the collection to find objects.
 *
 * The collection also keeps track of which GITPackFile it last successfully
 * extracted an object from, this is because linked objects are likely to be
 * stored within the same PACK file.
 */
@interface GITPackCollection : NSObject {
    NSArray *collection;
    GITPackFile *recent;
}

//! \name Creating and Initialising Collections
/*!
 * Creates and returns a new collection with the \c pack files in the \a directory.
 *
 * \param directory The path to the directory to collect the pack files from
 * \param error NSError describing any errors which occurred
 * \return a collection with the pack files from the \a directory
 * \sa collectionWithPackFiles:
 * \sa initWithPackFilesInDirectory:error:
 * \sa initWithPackFiles:
 */
+ (GITPackCollection *)collectionWithContentsOfDirectory: (NSString *)directory error: (NSError **)error;

/*!
 * Creates and returns a new collection from the array of \a files.
 *
 * \param files Array of GITPackFile objects
 * \return new collection
 * \sa initWithPackFiles:
 */
+ (GITPackCollection *)collectionWithPackFiles: (NSArray *)files;

/*!
 * Creates and returns a new collection with the \c pack files in the \a directory.
 *
 * \param directory The path to the directory to collect the pack files from
 * \param error NSError describing any errors which occurred
 * \return a collection with the pack files from the \a directory
 * \sa initWithPackFiles:
 */
- (id)initWithPackFilesInDirectory: (NSString *)directory error: (NSError **)error;

/*!
 * Creates and returns a new collection from the array of \a files.
 *
 * \param files Array of GITPackFile objects
 * \return new collection
 * \sa initWithPackFiles:
 */
- (id)initWithPackFiles: (NSArray *)files;

//! \name Object Extraction
/*!
 * Returns the first pack object found in the collection with the \a objectHash.
 *
 * If this method returns nil then it means that the object could not be found
 * in the collection, if there is an error then the \a error will not be nil.
 *
 * \param objectHash Hash identifying the object data to retrieve
 * \param error NSError describing the error which occurred
 * \return pack object for the specified \a objectHash or nil if not found
 */
- (GITPackObject *)unpackObjectWithSha1: (GITObjectHash *)objectHash error: (NSError **)error;

@end
