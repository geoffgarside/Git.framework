//
//  GITRefResolver.h
//  Git.framework
//
//  Created by Geoff Garside on 18/09/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITRepo, GITRef;

/*!
 * The \e GITRefResolver class provides methods to return GITRef
 * objects by their name. The class also provides methods to
 * obtain arrays of GITRef objects by \c tags, \c heads and \c remotes.
 */
@interface GITRefResolver : NSObject {
    GITRepo *repo;
    NSMutableDictionary *packedRefsCache;
}

@property (assign) GITRepo *repo;
@property (retain) NSMutableDictionary *packedRefsCache;

//! \name Creating and Initialising Ref Resolvers
/*!
 * Creates and returns an autoreleased Ref Resolver for the
 * given repository￼.
 *
 * \param theRepo The repository the receiver will resolve with
 * \return resolver initialised with the specified repository
 * \sa initWithRepo:
 */
+ (GITRefResolver *)resolverForRepo: (GITRepo *)theRepo;

/*!
 * Creates and returns a Ref Resolver for the given repository￼.
 *
 * \param theRepo The repository the receiver will resolve with
 * \return resolver initialised with the specified repository
 */
- (id)initWithRepo: (GITRepo *)theRepo;

//! \name Reference Resolving
/*!
 * Returns a reference by resolving the specified name.
 *
 * Resolves references in the following order:
 * \li \c refs/
 * \li \c refs/tags/
 * \li \c refs/heads/
 * \li \c refs/remotes/
 *
 * \param theName Name of the reference to resolve
 * \return Reference resolved from the specified name, or nil
 *         if the reference cannot be found or if an error occurred
 * \sa resolveRefWithName:error:
 */
- (GITRef *)resolveRefWithName: (NSString *)theName;

/*!
 * Returns a reference by resolving the specified name￼.
 *
 * Resolves references in the following order:
 * \li \c refs/
 * \li \c refs/tags/
 * \li \c refs/heads/
 * \li \c refs/remotes/
 *
 * \param theName Name of the reference to resolve
 * \param theError NSError describing the error that occurred
 * \return Reference resolved from the specified name, or nil
 *         if the reference cannot be found or if an error occurred
 */
- (GITRef *)resolveRefWithName: (NSString *)theName error: (NSError **)theError;

//! \name Gathering References
/*!
 * Returns an array of all the references in the receivers repository￼.
 *
 * \return array of all the references in the receivers repository
 */
- (NSArray *)allRefs;

/*!
 * Returns an array of all the \c tag references in the receivers repository￼.
 *
 * \return array of all the \c tag references in the receivers repository
 * \sa allRefs
 */
- (NSArray *)tagRefs;

/*!
 * Returns an array of all the \c head references in the receivers repository￼.
 *
 * \return array of all the \c head references in the receivers repository
 * \sa allRefs
 */
- (NSArray *)headRefs;

/*!
 * Returns an array of all the \c head references in the receivers repository￼.
 *
 * \return array of all the \c head references in the receivers repository
 * \sa allRefs
 */
- (NSArray *)remoteRefs;

@end
