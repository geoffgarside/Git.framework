//
//  GITBlob.h
//  Git.framework
//
//  Created by Geoff Garside on 13/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GITObject.h"


/*!
 * This class represents \e Blob objects in a git repository.
 *
 * Blob objects store the data which makes up the files of a repository,
 * these objects have no name associated with them and are only identified
 * by their content.
 */
@interface GITBlob : GITObject <GITObject> {
    NSData *content;        //!< object contents
}

//! \name Properties
@property (retain) NSData *content;

//! \name Creating Blobs
/*!
 * Creates and returns a blob from the \a data.
 *
 * The blob copies the \a data as its content and initialises the \a repo as its parent.
 * The \a error parameter will contain a description of any errors which occur though
 * at the moment there aren't any cases when an error would be raised when creating a
 * blob object.
 *
 * \param data The data to create the receiver with
 * \param objectHash The SHA1 hash of the receiver
 * \param repo The repository the receiver is a member of
 * \param error NSError describing the error if one occurs
 * \return A blob object
 */
+ (GITBlob *)blobFromData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)repo error: (NSError **)error;

@end
