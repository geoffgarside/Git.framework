//
//  GITCommit.h
//  Git.framework
//
//  Created by Geoff Garside on 13/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GITObject.h"


@class GITTree, GITObjectHash, GITActor, GITDateTime;

/*!
 * This class represents \e Commit objects in a git repository.
 *
 * Commit objects are markers of the state of a repository at a
 * specific moment in time, they reference trees which define the
 * file system structure of a repository at a given point.
 *
 * Commit objects look like the following, the parent may be repeated.
 * \code
 * tree 80655da8d80aaaf92ce5357e7828dc09adb00993
 * parent d8fd39d0bbdd2dcf322d8b11390a4c5825b11495
 * author A. Developer <dev@example.com> 444123000 +0000
 * committer A. Developer <dev@example.com> 444123000 +0000
 * 
 * A commit message meant to describe what this commit is all about
 * \endcode
 */
@interface GITCommit : GITObject <GITObject> {
    NSArray *parents;           //!< Array of GITCommit parents
    NSArray *parentShas;        //!< Array of GITObjectHash objects of the parents

    GITTree *tree;              //!< The tree object the commit references
    GITObjectHash *treeSha1;    //!< The hash of the tree object the commit references

    GITActor *author;           //!< Author of the commit
    GITActor *committer;        //!< Committer of the commit, different from author if the commit was created by patching

    GITDateTime *authorDate;    //!< Date the commit was created
    GITDateTime *committerDate; //!< Date the commit was committed to the repository via patching

    NSString *message;          //!< Commit message

    NSData *cachedData;         //!< Copy of the data of the object, used for lazy object loading
}

//! \name Properties
@property (copy) NSArray *parentShas;
@property (copy) NSArray *parents;
@property (retain) GITTree *tree;
@property (retain) GITActor *author;
@property (retain) GITActor *committer;
@property (retain) GITDateTime *authorDate;
@property (retain) GITDateTime *committerDate;
@property (copy) NSString *message;

//! \name Creating and Initialising Commits
/*!
 * Creates and returns a commit from the \a data.
 *
 * The \a data content is parsed to extract the information about the commit such
 * as the referenced tree, parents, author, committer, dates and the commit message.
 *
 * \param data The data describing the commit
 * \param objectHash The SHA1 hash of the receiver
 * \param repo The repository the commit is a member of
 * \param error NSError describing the error that occurred
 * \return A commit object from the \a data
 */
+ (GITCommit *)commitFromData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)repo error: (NSError **)error;

//! \name Properties
/*!
 * Returns the last SHA1 in the list of parent commits.
 *
 * \return SHA1 of the parent commit
 * \sa parentShas
 */
- (NSString *)parentSha1;

//! \name Flags
/*!
 * Returns YES if the receiver is a merge point, NO if it has only one parent.
 *
 * \return YES if the receiver is a merge point, NO if only one parent
 * \sa parentShas
 */
- (BOOL)isMerge;

/*!
 * Returns YES if the receiver if the first commit, NO otherwise.
 *
 * \return YES if the receiver is the first commit, NO otherwise.
 * \sa parentShas
 */
- (BOOL)isInitial;

@end
