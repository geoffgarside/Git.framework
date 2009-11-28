//
//  GITBranch.h
//  Git.framework
//
//  Created by Geoff Garside on 17/10/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITRepo, GITRef;

/*!
 * \c GITBranch objects provide an interface to branches.
 */
@interface GITBranch : NSObject {
    GITRepo *repo;
    GITRef *ref;
}

@property (retain) GITRepo *repo;
@property (retain) GITRef *ref;

/// \name Creating and Initialising Branches
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
 * Creates and returns a branch for the specified reference￼.
 *
 * \param theRef GITRef describing the branch
 * \return branch initialised with the reference
 */
- (id)initFromRef: (GITRef *)theRef;

/// \name Branch Information
/*!
 * Returns the name of the branch￼.
 *
 * \return name of the branch
 */
- (NSString *)name;

@end
