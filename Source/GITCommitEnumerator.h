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

@interface GITCommitEnumerator : NSEnumerator {
    GITCommit *head;
    GITCommitEnumeratorMode mode;
    NSMutableArray *queue;
    NSMutableSet *visited;              //!< Stores "grey" commits
    BOOL firstPass;
}

+ (GITCommitEnumerator *)enumeratorFromCommit: (GITCommit *)head;
+ (GITCommitEnumerator *)enumeratorFromCommit: (GITCommit *)head mode: (GITCommitEnumeratorMode)mode;

- (id)initFromCommit: (GITCommit *)theHead mode: (GITCommitEnumeratorMode)theMode;

@end
