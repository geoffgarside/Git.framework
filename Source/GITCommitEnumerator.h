//
//  GITCommitEnumerator.h
//  Git.framework
//
//  Created by Geoff Garside on 06/02/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    GITCommitEnumeratorBreadthFirstMode,
    GITCommitEnumeratorDepthFirstMode,
} GITCommitEnumeratorMode;

@class GITCommit;

/*!
 * ---
 * Modes cannot be mixed, most specifically because the queue is used
 * in different ways between the Breadth and Depth traversal algorithms.
 * +++
 */
@interface GITCommitEnumerator : NSEnumerator {
    GITCommit *head;
    GITCommitEnumeratorMode mode;
    NSMutableArray *queue;
    NSMutableArray *merges;
    NSMutableSet *visited;              //!< Stores "grey" commits
    BOOL firstPass;
}

+ (GITCommitEnumerator *)enumeratorFromCommit: (GITCommit *)head;
+ (GITCommitEnumerator *)enumeratorFromCommit: (GITCommit *)head mode: (GITCommitEnumeratorMode)mode;

- (id)initFromCommit: (GITCommit *)theHead mode: (GITCommitEnumeratorMode)theMode;

@end
