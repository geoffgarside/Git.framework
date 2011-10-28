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
@property (assign) NSMutableArray *queue;
@property (assign) NSMutableArray *merges;
@property (assign) NSMutableSet *visited;

- (id)nextObjectInBreadthFirstTraversal;
- (id)nextObjectInDepthFirstTraversal;
@end

@implementation GITCommitEnumerator

@synthesize head, mode, queue, merges, visited;

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

    if ( self.mode == GITCommitEnumeratorDepthFirstMode )
        self.merges = [[NSMutableArray alloc] init];

    firstPass = YES;

    return self;
}

- (void)dealloc {
    self.head = nil;
    [queue release];
    self.queue = nil;
    [merges release];
    self.merges = nil;
    [visited release];
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

- (NSArray *)allObjectsUntilObjectHash: (GITObjectHash *)hash {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];

    id object;
    while ( object = [self nextObject] ) {
        [array addObject:object];
        if ( [hash isEqualToObjectHash:[object sha1]] )
            break;
    }

    return [NSArray arrayWithArray:array];
}

- (NSArray *)allObjectsUntilCommit: (GITCommit *)commit {
    return [self allObjectsUntilObjectHash:[commit sha1]];
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
- (id)nextObjectInDepthFirstTraversalFromMergePoint {
    GITCommit *merge = nil;
    GITObjectHash *parent = nil;

    if ( [merges count] == 0 )
        return nil;

    merge = [self nextCommit:[merges objectAtIndex:0]];
    [merges removeObjectAtIndex:0];

    for ( parent in [merge parentShas] ) {
        if ( ![visited containsObject:parent] ) {
            [queue insertObject:parent atIndex:0];
            [visited addObject:parent];
            return [self nextObjectInDepthFirstTraversal];
        }
    }

    return nil;
}
- (id)nextObjectInDepthFirstTraversal {
    GITCommit *current = nil;
    GITObjectHash *parent = nil;

    if ( [queue count] == 0 )
        return [self nextObjectInDepthFirstTraversalFromMergePoint];

    current = [self nextCommit:[queue objectAtIndex:0]];    //!< Get the commit of the head of the queue
    [queue removeObjectAtIndex:0];

    if ( [current isMerge] )
        [merges insertObject:[current sha1] atIndex:0];

    for ( parent in [current parentShas] ) {
        if ( ![visited containsObject:parent] ) {           //!< We've not yet seen this commit
            [queue insertObject:parent atIndex:0];          //!< Put our parent at the head of the queue
            [visited addObject:parent];                     //!< Mark the parent as visited
            return current;                                 //!< Found a parent for this commit, we're done
        }
    }

    return current;
}

@end
