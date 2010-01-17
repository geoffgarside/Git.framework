//
//  GITPackObject.h
//  Git.framework
//
//  Created by Geoff Garside on 07/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GITObject.h"


/*!
 * The GITPackObject class aids in the extraction of objects from PACK files.
 *
 * The class combines the data of the object and the indicated type for later
 * conversion into a normal git object type such as \e commit, \e tree, \e blob
 * or \e tag.
 *
 * When loading an object from a PACK file you do not create instances of this
 * class directly, rather you call the -unpackObjectWithSha1:error: method on
 * the GITPackFile and an instance of this class is returned.
 */
@interface GITPackObject : NSObject {
    GITObjectType type;     //!< Type of the object the data represents
    NSData *data;           //!< Data of the packed object
    GITObjectHash *sha1;    //!< SHA1 Hash of the packed object
}

//! \name Properties
@property (assign) GITObjectType type;
@property (copy) NSData *data;
@property (retain) GITObjectHash *sha1;
@property (readonly,assign) NSUInteger length;      //!< size of the receivers data

//! \name Creating and Initialising GITPackObjects
/*!
 * Create and return a new PACK object.
 *
 * \param packData Data to create the PACK object from
 * \param objectHash The SHA1 hash of the object
 * \param objectType Type of object the \a packData represents
 * \return new pack object
 * \sa initWithData:type:
 */
+ (GITPackObject *)packObjectWithData: (NSData *)packData sha1: (GITObjectHash *)objectHash type: (GITObjectType)objectType;

/*!
 * Create and return a new PACK object.
 *
 * \param packData Data of the object
 * \param objectHash The SHA1 hash of the object
 * \param objectType Type of the object the \a packData represents
 * \return new pack object
 * \sa packObjectWithData:type:
 */
- (id)initWithData: (NSData *)packData sha1: (GITObjectHash *)objectHash type: (GITObjectType)objectType;

//! \name Obtaining the contained object
/*!
 * Returns the object contained in the receiver and sets the \a repo of the object.
 *
 * \param repo Repository the object should belong to
 * \param error NSError describing any errors which occurred
 * \return object in the \a repo
 * \sa GITPackFile::unpackObjectWithSha1
 */
- (GITObject *)objectInRepo: (GITRepo *)repo error: (NSError **)error;

//! \name Patching GITPackObjects
/*!
 * Returns a new PACK object by patching the receivers data with \a deltaData.
 *
 * \param deltaData Data to patch the receivers data with
 * \return new PACK object with the result of patching the receivers data with \a deltaData
 */
- (GITPackObject *)packObjectByDeltaPatchingWithData: (NSData *)deltaData;

@end
