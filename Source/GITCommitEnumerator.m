//
//  GITCommitEnumerator.m
//  Git.framework
//
//  Created by Geoff Garside on 06/02/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITCommitEnumerator.h"
#import "GITObjectHash.h"
#import "GITCommit.h"
#import "GITRepo.h"


@interface GITCommitEnumerator ()
@property (retain) GITCommit *head;
@property (assign) GITCommitEnumeratorMode mode;
@property (retain) NSMutableArray *queue;
@property (retain) NSMutableSet *visited;

- (id)nextObjectInBreadthFirstTraversal;
- (id)nextObjectInDepthFirstTraversal;
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

#pragma mark -
#pragma mark Enumeration Helpers
- (GITRepo *)repo {
    return self.head.repo;
}

- (GITCommit *)nextCommit: (GITObjectHash *)objectHash {
    if ( firstPass ) {
        firstPass = NO;
        return self.head;
    } else {
        return (GITCommit *)[[self repo] objectWithSha1:objectHash error:NULL];
    }
}

- (NSArray *)allObjectsUntilCommit: (GITCommit *)commit {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];

    id object;
    while ( object = [self nextObject] ) {
        [array addObject:object];
        if ( [commit isEqualTo:object] )
            break;
    }

    return [NSArray arrayWithArray:array];
}

- (NSArray *)allObjectsUntilObjectHash: (GITObjectHash *)hash {
    return [self allObjectsUntilCommit:(GITCommit *)[self.head.repo objectWithSha1:hash error:NULL]];
}

- (NSArray *)allObjectsUntil: (id)obj {
    if ( [obj isKindOfClass:[GITCommit class]] )
        return [self allObjectsUntilCommit:obj];
    else if ( [obj isKindOfClass:[GITObjectHash class]] )
        return [self allObjectsUntilObjectHash:obj];
    else
        return nil;
}

#pragma mark -
#pragma mark NSEnumerator Methods
- (NSArray *)allObjects {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];

    id commit;
    while ( commit = [self nextObject] ) {
        [array addObject:commit];
    }

    return [NSArray arrayWithArray:array];
}

- (id)nextObject {
    if ( mode == GITCommitEnumeratorBreadthFirstMode )
        return [self nextObjectInBreadthFirstTraversal];
    else
        return [self nextObjectInDepthFirstTraversal];
}

#pragma mark -
#pragma mark Breadth First Traversal Algorithm
- (id)nextObjectInBreadthFirstTraversal {
    GITCommit *current = nil;
    GITObjectHash *parent = nil;

    if ( [queue count] == 0 )
        return nil;

    current = [self nextCommit:[queue objectAtIndex:0]];

    for ( parent in [current parentShas] ) {    //!< Grab all the parents of the current commit
        if ( [visited containsObject:parent] )  //!< If we've already seen them then onwards!!!
            continue;
        [queue addObject:parent];               //!< Queue the parent so we can check it out next time
        [visited addObject:parent];             //!< "mark" parent as visited
    }

    [queue removeObjectAtIndex:0];

    return current;
}

#pragma mark Depth First Traversal Algorithm
- (id)nextObjectInDepthFirstTraversal {
}

@end
