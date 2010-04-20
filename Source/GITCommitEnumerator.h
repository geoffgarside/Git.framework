//
//  GITCommitEnumerator.h
//  Git.framework
//
//  Created by Geoff Garside on 06/02/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>

//! \name Constants
/*!
 * Flags for indicating enumeration methods
 */
typedef enum {
    GITCommitEnumeratorBreadthFirstMode,    //!< A flag indicating the enumerator should use breadth first traversal
    GITCommitEnumeratorDepthFirstMode,      //!< A flag indicating the enumerator should use depth first traversal
} GITCommitEnumeratorMode;

@class GITCommit;

/*!
 * An NSEnumerator subclass which provides the ability to iterate or collect the
 * series of parents of a given commit.
 *
 * The enumerator provides two distinct enumeration modes. The first and default mode
 * is breadth first traversal and is specified via GITCommitEnumeratorBreadthFirstMode
 * passed as the <tt>mode</tt> argument to either <tt>+enumeratorFromCommit:mode:</tt> or
 * <tt>-initFromCommit:mode:</tt> method. The second enumeration mode performs a depth first
 * traversal and is specified via GITCommitEnumeratorDepthFirstMode.
 *
 * \internal
 * Modes cannot be mixed, most specifically because the queue is used
 * in different ways between the Breadth and Depth traversal algorithms.
 */
@interface GITCommitEnumerator : NSEnumerator {
    GITCommit *head;                    //!< Enumerator starting point
    GITCommitEnumeratorMode mode;       //!< Mode of enumeration
    NSMutableArray *queue;              //!< Queue of commit names
    NSMutableArray *merges;             //!< DFS list of revisit points
    NSMutableSet *visited;              //!< Stores "grey" commits
    BOOL firstPass;                     //!< Flag indicating if -nextObject is going through its first call
}

//! \name Creating and Initialising Enumerators
/*!
 * Creates and returns an enumerator from the given commit \a head.
 *
 * The enumerator is created with the default enumeration mode. The default enumeration
 * mode is GITCommitEnumeratorBreadthFirstMode indicating the use of breadth first
 * traversal algorithm.
 *
 * \param head Commit object from which the receiver will enumerate from
 * \return An enumerator which will start from the \a head using breadth first traversal
 * \sa enumeratorFromCommit:mode:
 * \sa initFromCommit:mode:
 */
+ (GITCommitEnumerator *)enumeratorFromCommit: (GITCommit *)head;

/*!
 * Creates and returns an enumerator from the given commit \a head using the provided enumeration \a mode.
 *
 * \param head Commit object from which the receiver will enumerate from
 * \param mode A GITCommitEnumeratorMode flag indicating the type of enumeration to be used
 * \return An enumerator object which will start from the \a head using the specified \a mode
 * \sa enumeratorFromCommit:
 * \sa initFromCommit:mode:
 */
+ (GITCommitEnumerator *)enumeratorFromCommit: (GITCommit *)head mode: (GITCommitEnumeratorMode)mode;

/*!
 * Initialises a newly allocated enumerator object initialised with the given commit \a head and \a mode.
 *
 * \param head Commit object from which the receiver will enumerate from
 * \param mode A GITCommitEnumeratorMode flag indicating the type of enumeration to be used
 * \return An enumerator object initialised with the given commit \a head and \a mode
 * \sa enumeratorFromCommit:
 * \sa enumeratorFromCommit:mode:
 */
- (id)initFromCommit: (GITCommit *)head mode: (GITCommitEnumeratorMode)mode;

@end
