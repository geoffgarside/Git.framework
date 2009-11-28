//
//  GITRef.h
//  Git.framework
//
//  Created by Geoff Garside on 20/09/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITRepo;

/*!
 * \e GITRef objects provide access to git references.
 */
@interface GITRef : NSObject {
    GITRepo *repo;

    BOOL link;
    NSString *name;
    NSString *targetName;
}

@property (retain) GITRepo *repo;

/// \name Properties
/*!
 * Name of the reference.
 */
@property (copy) NSString *name;

/*!
 * Flag indicating if the reference is a link to another reference or not.
 *
 * The accessor for this property is \c isLink
 */
@property (assign, getter=isLink) BOOL link;

/*!
 * Value of the reference.
 *
 * If the receiver is a link then \c targetName contains the name of the
 * reference it points to. If the receiver is not a link then \c targetName
 * contains the SHA1 hash of the GITObject the reference points to.
 */
@property (copy) NSString *targetName;

/// \name Creating and Initialising References
/*!
 * Creates an autoreleased reference with the specified name, target and repository￼.
 *
 * \param theName Name of the reference
 * \param theTarget Link target or SHA1 hash of object
 * \param theRepo Repository the reference exists in
 * \return reference with the specified name, target and repository￼
 * \sa initWithName:andTarget:inRepo:
 */
+ (id)refWithName: (NSString *)theName andTarget: (NSString *)theTarget inRepo: (GITRepo *)theRepo;

/*!
 * Initialises a reference with the specified name, target and repository￼
 *
 * \param theName Name of the reference
 * \param theTarget Link target or SHA1 hash of object
 * \param theRepo Repository the reference exists in
 * \return reference with the specified name, target and repository￼
 */
- (id)initWithName: (NSString *)theName andTarget: (NSString *)theTarget inRepo: (GITRepo *)theRepo;

// Could be a commit, tag
//- (GIT *)target;

/*!
 * Returns the reference linked to by the receiver, returns the receiver if not a link.
 *
 * \return reference linked to by the receiver, returns the receiver if not a link
 */
- (GITRef*)resolve;

@end
