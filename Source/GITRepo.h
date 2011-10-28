//
//  GITRepo.h
//  Git.framework
//
//  Created by Geoff Garside on 14/09/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GITCommitEnumerator.h"             //!< For GITCommitEnumeratorMode


@class GITRefResolver, GITPackCollection, GITObject, GITObjectHash, GITCommit;
@class GITRevList;

/*!
 * The GITRepo class declares the programmatic interface to the repository.
 */
@interface GITRepo : NSObject {
    NSString *root;                         //!< Path to the repository root
    BOOL bare;                              //!< Flag indicating if the repo is bare, accessor isBare

    NSString *objectsDirectory;             //!< Cached path to the .git/objects directory

    GITRefResolver *refResolver;            //!< Refs Resolver for the repo
    GITPackCollection *packCollection;      //!< PACK files collection
}

//! \name Properties
@property (copy) NSString *root;
@property (assign,getter=isBare) BOOL bare;
@property (retain) GITRefResolver *refResolver;

//! \name Creating and Initialising Repositories
/*!
 * Returns a repository using the current working directory as the repository root.
 *
 * \return repository initialised at the current directory, or nil if an error occurred
 * \sa repoWithRoot:
 */
+ (GITRepo *)repo;

/*!
 * Returns a repository with theRoot as the repository root.
 *
 * \param theRoot Path to the repository root
 * \return repository initialised at the specified path, or nil if an error occurred
 * \sa repoWithRoot:error:
 */
+ (GITRepo *)repoWithRoot: (NSString *)theRoot;

/*!
 * Returns a repository with theRoot as the repository root.
 *
 * \param theRoot Path to the repository root
 * \param theError NSError describing any errors which occurred during initialisation
 * \return repository initialised at the specified path, or nil if an error occurred
 * \sa initWithRoot:error:
 */
+ (GITRepo *)repoWithRoot: (NSString *)theRoot error: (NSError **)theError;

/*!
 * Returns a repository initialised with the root specified by \a theRoot.
 *
 * \param theRoot Path to the repository root
 * \return repository initialised at the specified path, or nil if an error occurred
 * \sa initWithRoot:error:
 */
- (id)initWithRoot: (NSString *)theRoot;

/*!
 * Returns a repository initialised with the root specified by \a theRoot.
 *
 * If the path specified by \a theRoot ends in ".git" then the repository is assumed
 * to be a bare repository, if it doesn't then ".git" is appended to \a theRoot as a
 * path component.
 * The directory at the path specified is subjected to the following tests
 *
 * \li the path specified exists and is a directory
 * \li the path specified is both readable and writable by the current user
 * \li the path looks like a git directory, ie has a certain structure and files
 *
 * provided the path specified passes these tests then the repository object is
 * returned. If any fail then nil is returned and the NSError is filled with details.
 *
 * \param theRoot Path to the repository root
 * \param theError NSError describing the error which occurred during initialisation
 * \return repository initialised at the specified path, or nil if an error occurred
 */
- (id)initWithRoot: (NSString *)theRoot error: (NSError **)theError;

//! \name Creating New Repositories
/*!
 * Creates a repository at the specified \a path.
 *
 * \param path Path at which to create the repository. A bare repository is created if \a path ends in <tt>.git</tt>.
 * \return repository created at the \a path
 */
+ (GITRepo *)createRepoAtPath: (NSString *)path;

/*!
 * Creates a repository at the specified \a path.
 *
 * \param path Path at which to create the repository. A bare repository is created if \a path ends in <tt>.git</tt>.
 * \param[out] error NSError describing the error which occurred during creation or initialisation.
 * \return repository created at the \a path
 */
+ (GITRepo *)createRepoAtPath: (NSString *)path error: (NSError **)error;

/*!
 * Creates a repository at the specified \a path.
 *
 * \param path Path at which to create the repository. A bare repository is created if \a path ends in <tt>.git</tt>.
 * \return repository created at the \a path
 */
- (id)initAtPath: (NSString *)path;

/*!
 * Creates a repository at the specified \a path.
 *
 * \param path Path at which to create the repository. A bare repository is created if \a path ends in <tt>.git</tt>.
 * \param[out] error NSError describing the error which occurred during creation or initialisation.
 * \return repository created at the \a path
 */
- (id)initAtPath: (NSString *)path error: (NSError **)error;

//! \name Instance Methods
/*!
 * Returns an array containing branches from the receiver.
 *
 * The GITBranch objects in the array are created from the array of GITRef objects
 * returned by GITRefResolver::headRefs processing of <code>refs/heads</code>.
 *
 * \return array of branches from the receiver
 * \sa GITRefResolver
 */
- (NSArray *)branches;

/*!
 * Returns an array containing remotes from the receiver.
 *
 * The GITRemote objects in the array are created from the array of GITRef objects
 * returned by GITRefResolver::remoteRefs processing of <code>refs/remotes</code>.
 *
 * \return array of remotes from the receiver
 * \sa GITRefResolver
 */
- (NSArray *)remoteBranches;

/*!
 * Returns an array containing tags from the receiver.
 *
 * The GITTag objects in the array are created from the array of GITRef objects
 * returned by GITRefResolver::tagRefs processing of <code>refs/tags</code>.
 *
 * \return array of tags from the receiver
 * \sa GITRefResolver
 */
- (NSArray *)tags;

//! \name Retrieving Objects
/*!
 * Returns the GITObject identified by the \a objectHash.
 *
 * Attempts to load the object from the file system first, if this fails then it turns to the
 * packCollection to attempt loading from the repositories PACK files.
 *
 * \param objectHash Hash identifying the object to retrieve
 * \param error NSError describing any errors which occur
 * \return object identified by \a objectHash or nil if it can't be found or an error occurred
 */
- (GITObject *)objectWithSha1: (GITObjectHash *)objectHash error: (NSError **)error;

//! \name Retrieving Specific commit points
/*!
 * Returns the commit object for the current HEAD of the receiver.
 *
 * \return commit object for the HEAD of the receiver
 */
- (GITCommit *)head;

//! \name Enumerating Commits
/*!
 * Returns an enumerator object from the HEAD of the receiver.
 *
 * \return enumerator object from the HEAD of the reciever
 * \sa enumeratorWithMode:
 */
- (GITCommitEnumerator *)enumerator;

/*!
 * Returns an enumerator object from the HEAD of the receiver with the given \a mode.
 *
 * \param mode Enumerator mode to be used by the returned enumerator
 * \return enumerator object from the HEAD of the receiver with the given \a mode
 * \sa enumerator
 */
- (GITCommitEnumerator *)enumeratorWithMode: (GITCommitEnumeratorMode)mode;

/*!
 * Returns a RevList object based on the HEAD of the receiver.
 *
 * \return RevList object based on the HEAD of the receiver.
 * \sa revListFromCommit:
 */
- (GITRevList *)revList;

/*!
 * Returns a RevList object based on the given \a head.
 *
 * \return RevList object based on the given \a head.
 * \sa revList
 */
- (GITRevList *)revListFromCommit: (GITCommit *)head;

/*!
 * Returns an array of commit objects sorted by their commit date.
 *
 * The result of this method is equivalent to <tt>git rev-list HEAD</tt>.
 *
 * \deprecated Use [[repo revList] arrayOfCommitsSortedByDate] instead
 * \return array of commits sorted by date
 * \sa revList
 * \sa GITRevList::arrayOfCommitsSortedByDate
 */
- (NSArray *)revListSortedByDate __attribute__ ((deprecated));

/*!
 * Returns an array of commit objects sorted by topology.
 *
 * The result of this method is equivalent to <tt>git rev-list --topo-order HEAD</tt>.
 *
 * \deprecated Use [[repo revList] arrayOfCommitsSortedByTopology] instead
 * \return array of commits sorted by topology
 * \sa revList
 * \sa GITRevList::arrayOfCommitsSortedByTopology
 */
- (NSArray *)revListSortedByTopology __attribute__ ((deprecated));

/*!
 * Returns an array of commit objects sorted by topology and commit date.
 *
 * The result of this method is equivalent to <tt>git rev-list --date-order HEAD</tt>.
 *
 * \deprecated Use [[repo revList] arrayOfCommitsSortedByTopologyAndDate] instead
 * \return array of commits sorted by topology and date
 * \sa revList
 * \sa GITRevList::arrayOfCommitsSortedByTopologyAndDate
 */
- (NSArray *)revListSortedByTopologyAndDate __attribute__ ((deprecated));

@end
