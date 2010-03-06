//
//  GITCommitEnumerator.m
//  Git.framework
//
//  Created by Geoff Garside on 06/02/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITCommitEnumerator.h"


@interface GITCommitEnumerator ()
@property (retain) GITCommit *head;
@property (assign) GITCommitEnumeratorMode mode;
@property (retain) NSMutableArray *queue;
@property (retain) NSMutableSet *visited;
@end

@implementation GITCommitEnumerator

@synthesize head, mode, queue, visited;

+ (GITCommitEnumerator *)enumeratorFromCommit: (GITCommit *)head {
    return [self enumeratorFromCommit:head mode:GITCommitEnumeratorBreadthFirstMode];
}

+ (GITCommitEnumerator *)enumeratorFromCommit: (GITCommit *)head mode: (GITCommitEnumeratorMode)mode {
    return [[[self alloc] initFromCommit:head mode:mode] autorelease];
}

- (id)initFromCommit: (GITCommit *)theHead mode: (GITCommitEnumeratorMode)theMode {
    if ( ![super init] )
        return nil;

    self.head = theHead;
    self.mode = theMode;

    self.queue = [[NSMutableArray alloc] initWithObjects:[theHead sha1], nil];
    self.visited = [[NSMutableSet alloc] initWithObjects:[theHead sha1], nil];

    firstPass = YES;

    return self;
}

- (void)dealloc {
    self.head = nil;
    self.queue = nil;
    self.visited = nil;
    [super dealloc];
}

@end
