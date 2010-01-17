//
//  GITBranch.h
//  Git.framework
//
//  Created by Geoff Garside on 17/10/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITRepo, GITRef, GITCommit;

/*!
 * This class represents \c GITBranch objects.
 *
 * Branches are threads of commits in a repository, they refer to the
 * HEAD of a thread.
 */
@interface GITBranch : NSObject {
    GITRepo *repo;      //!< Repository the branch is part of
    GITRef *ref;        //!< Ref the branch points to
    BOOL remote;        //!< Flag indicating if the branch is a remote branch
}

//! \name Properties
@property (retain) GITRepo *repo;
@property (retain) GITRef *ref;
@property (assign,getter=isRemote) BOOL remote;

//! \name Creating and Initialising Branches
/*!
 * Creates and returns a branch by the name specified.
 *
 * The name of the branch is used to resolve the reference for the branch,
 * the resolved reference is used to create the GITBranch.
 *
 * \param theName Name of the branch
 * \param theRepo Repository to resolve the branch in
 * \return branch initialised with the name specified, or nil if the branch can't be resolved
 * \sa branchFromRef:
 * \sa initFromRef:
 */
+ (GITBranch *)branchWithName: (NSString *)theName inRepo: (GITRepo *)theRepo;

/*!
 * Creates and returns an autoreleased branch using the reference specified￼.
 *
 * \param theRef GITRef describing the branch
 * \return branch initialised with the reference
 * \sa initFromRef:
 */
+ (GITBranch *)branchFromRef: (GITRef *)theRef;

/*!
 * Creates and returns a branch for the specified reference.
 *
 * \param theRef GITRef describing the branch
 * \return branch initialised with the reference
 */
- (id)initFromRef: (GITRef *)theRef;

//! \name Branch Information
/*!
 * Returns the name of the branch.
 *
 * \return name of the branch
 */
- (NSString *)name;

/*!
 * Returns the commit which represents the HEAD of the receiver.
 *
 * \return Commit HEAD of the receiver
 */
- (GITCommit *)head;

@end
