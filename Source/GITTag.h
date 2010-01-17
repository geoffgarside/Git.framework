//
//  GITTag.h
//  Git.framework
//
//  Created by Geoff Garside on 13/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GITObject.h"


@class GITObjectHash, GITActor, GITDateTime;

/*!
 * This class represents \e Tag objects in a git repository.
 *
 * Tag objects attach a conventional name to another object in the repository,
 * typically a commit. The creation of the tag is dated and attributed to a
 * specific actor within the repository, freqently a description of the meaning
 * of the name is included.
 *
 * \todo Document the internal structure of the tag object
 * \verbatim
 * object 1615307cc4523f183e777df67f168c86908e8007
 * type commit
 * tag v1.0.0
 * tagger A. Developer <dev@example.com> 444123000 +0000
 *
 * A tag message meant to describe what this tag defines
 * \endverbatim
 */
@interface GITTag : GITObject <GITObject> {
    NSString *name;                 //!< Name of the tag

    GITObjectType  targetType;      //!< Type of the target so we can get it later
    GITObjectHash *targetSha1;      //!< Hash of the target so we can get it later
    GITObject     *target;          //!< Cache of the target once we've found it

    GITActor      *tagger;          //!< Actor who created the tag
    GITDateTime   *taggerDate;      //!< Date the tag was created

    NSString      *message;         //!< Tag message

    NSData *cachedData;
}

//! \name Properties
@property (copy) NSString *name;
@property (retain) GITObject *target;
@property (retain) GITActor *tagger;
@property (retain) GITDateTime *taggerDate;
@property (copy) NSString *message;

//! \name Creating and Initialising Tags
/*!
 * Creates and returns a tag from the \a data.
 *
 * The \a data content is parsed to extract the information about the tag such
 * as the name, referenced object, tagger, dates and the tag message.
 *
 * \param data The data describing the tag
 * \param objectHash The SHA1 hash of the receiver
 * \param repo The repository the tag is a member of
 * \param error NSError describing the error that occurred
 * \return A tag object from the \a data
 */
+ (GITTag *)tagFromData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)repo error: (NSError **)error;

@end
