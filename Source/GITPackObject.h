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
 */
@interface GITPackObject : NSObject {
    GITObjectType type;
    NSData *data;
}

@property (assign) GITObjectType type;
@property (copy) NSData *data;

/*!
 * Create and return a new PACK object.
 *
 * \param packData Data to create the PACK object from
 * \param objectType Type of object the \a packData represents
 * \return new pack object
 * \sa initWithData:type:
 */
+ (GITPackObject *)packObjectWithData: (NSData *)packData type: (GITObjectType)objectType;

/*!
 * Create and return a new PACK object.
 *
 * \param packData Data of the object
 * \param objectType Type of the object the \a packData represents
 * \return new pack object
 * \sa packObjectWithData:type:
 */
- (id)initWithData: (NSData *)packData type: (GITObjectType)objectType;

/*!
 * Returns a new PACK object by patching the receivers data with \a deltaData.
 *
 * \param deltaData Data to patch the receivers data with
 * \return new PACK object with the result of patching the receivers data with \a deltaData
 */
- (GITPackObject *)packObjectByDeltaPatchingWithData: (NSData *)deltaData;

@end
