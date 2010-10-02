//
//  GITRevList.h
//  Git.framework
//
//  Created by Geoff Garside on 11/07/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITCommit, GITGraph;

/*!
 * The GITRevList class lists commit objects in reverse chronological order. A subset
 * of the commit history can be excluded or negated from the list by calling -subtractDescendentsFromCommit:
 * which will remove all commits reachable from the specified commit from the list.
 *
 * Sorted lists of commits are provided through one of the <tt>-arrayOfCommitsSortedBy*</tt> methods.
 */
@interface GITRevList : NSObject {
    GITGraph *graph;
    NSMutableArray *excluded;
}

//! \name Creating and Initialising Rev-Lists
/*!
 * Creates and returns a rev list object with the history from the \a head commit.
 *
 * \param head Commit object to list from
 * \return New rev list object with the history of the \a head commit.
 */
+ (GITRevList *)revListWithCommit: (GITCommit *)head;

/*!
 * Initializes and returns a rev list object with history from the \a head commit.
 *
 * \param head Commit object to list from
 * \return Rev list object with the history of the \a head commit.
 */
- (id)initWithCommit: (GITCommit *)head;

//! \name Modifying Rev-Lists
/*!
 * Removes commits from the receiver which are in the history of the given \a tail commit.
 */
- (void)subtractDescendentsFromCommit: (GITCommit *)tail;

//! \name Sorted Lists from Rev-Lists
/*!
 * Returns an array of commit objects sorted by their commit date.
 *
 * The result of this method is equivalent to <tt>git rev-list</tt>.
 *
 * \return array of commits sorted by date
 */
- (NSArray *)arrayOfCommitsSortedByDate;

/*!
 * Returns an array of commit objects sorted by topology.
 *
 * The result of this method is equivalent to <tt>git rev-list --topo-order</tt>.
 *
 * \return array of commits sorted by topology
 */
- (NSArray *)arrayOfCommitsSortedByTopology;

/*!
 * Returns an array of commit objects sorted by topology and commit date.
 *
 * The result of this method is equivalent to <tt>git rev-list --date-order</tt>.
 *
 * \return array of commits sorted by topology and date
 */
- (NSArray *)arrayOfCommitsSortedByTopologyAndDate;

/*!
 * Returns an array of the objects which are reachable from the head of the receiver.
 *
 * This is primarily used when collecting the list of objects to include in a PACK file
 * prior to generation.
 *
 * \return Array of objects reachable from the head of the receiver.
 */
- (NSArray *)arrayOfReachableObjects;

/*!
 * Returns an array of the objects and tags which are reachable from the head of the receiver.
 *
 * \param tags Array of tags to be considered for inclusion in the resulting array. This should
 * be an inclusive list of all tags which might be reachable from the head of the receiver.
 * \return Array of objects and tags reachable from the head of the receiver.
 */
- (NSArray *)arrayOfReachableObjectsAndTags: (NSArray *)tags;

@end
