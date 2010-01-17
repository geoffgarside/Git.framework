//
//  GITLooseObject.h
//  Git.framework
//
//  Created by Geoff Garside on 14/01/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GITObject.h"


/*!
 * The GITLooseObject class aids in the extraction of objects from loose files.
 *
 * The class combines the data of the object and the indicated type for later
 * conversion into a normal git object type such as \e commit, \e tree, \e blob
 * or \e tag.
 *
 * When loading an object from the file system you create an instance of this
 * class directly, this is opposed to the way in which is PACK counterpart
 * GITPackObject is used.
 */
@interface GITLooseObject : NSObject {
    GITObjectType type;     //!< Type of the object the data represents
    NSData *data;           //!< Data of the packed object
}

//! \name Properties
@property (assign) GITObjectType type;
@property (copy) NSData *data;
@property (assign,readonly) NSUInteger length;  //!< Size of the receivers data

//! \name Creating and Initialising Loose Objects
/*!
 * Creates and returns a loose object identified by the \a objectHash from the \a directory specified.
 *
 * Loads data from the file system for the object matching the \a objectHash. The object prefix is extracted
 * from the loaded data to determine the object type of the data.
 *
 * \param objectHash Hash identifying the object to retrieve
 * \param directory Directory to locate the object within
 * \param error NSError describing any errors which occurred
 * \return Loose object containing the type and data of the object or nil if not found or an error occurred
 * \sa initWithSha1:from:error:
 */
+ (GITLooseObject *)looseObjectWithSha1: (GITObjectHash *)objectHash from: (NSString *)directory error: (NSError **)error;

/*!
 * Creates and returns a loose object identified by the \a objectHash from the \a directory specified.
 *
 * Loads data from the file system for the object matching the \a objectHash. The object prefix is extracted
 * from the loaded data to determine the object type of the data.
 *
 * \param objectHash Hash identifying the object to retrieve
 * \param directory Directory to locate the object within
 * \param error NSError describing any errors which occurred
 * \return Loose object containing the type and data of the object or nil if not found or an error occurred
 * \sa looseObjectWithSha1:from:error:
 */
- (id)initWithSha1: (GITObjectHash *)objectHash from: (NSString *)directory error: (NSError **)error;

//! \name Obtaining the contained object
/*!
 * Returns the object contained in the receiver and sets the \a repo of the object.
 *
 * \param repo Repository the object should belong to
 * \param error NSError describing any errors which occurred
 * \return object in the \a repo
 */
- (GITObject *)objectInRepo: (GITRepo *)repo error: (NSError **)error;

@end
