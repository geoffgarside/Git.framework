//
//  GITGraph.m
//  Git.framework
//
//  Created by Geoff Garside on 26/04/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITGraph.h"
#import "GITGraphNode.h"
#import "GITRepo.h"
#import "GITCommit.h"
#import "GITObjectHash.h"
#import "GITCommitEnumerator.h"


const NSUInteger kMaxSwimmersInPool = 1000;     //!< \see buildWithStartingNode:

@implementation GITGraph

+ (GITGraph *)graph {
    return [[[self alloc] init] autorelease];
}
+ (GITGraph *)graphWithStartingCommit: (GITCommit *)commit {
    return [[[self alloc] initWithStartingCommit:commit] autorelease];
}

- (id)init {
    if ( ![super init] )
        return nil;

    nodes = [[NSMutableDictionary alloc] init];
    edgeCounter = 0;

    return self;
}
- (id)initWithStartingCommit: (GITCommit *)commit {
    if ( ![self init] )
        return nil;

    [self buildWithStartingCommit:commit];

    return self;
}
- (void)dealloc {
    [nodes release];
    [super dealloc];
}

- (NSArray *)nodes {
    return (NSArray *)[nodes allValues];
}

- (BOOL)hasNode: (GITGraphNode *)node {
    if ( [nodes objectForKey:[node key]] )
        return YES;
    return NO;
}
- (void)addNode: (GITGraphNode *)node {
    [nodes setObject:node forKey:[node key]];
}
- (void)removeNode: (GITGraphNode *)node {
    [nodes removeObjectForKey:[node key]];
}
- (void)addEdgeFromNode: (GITGraphNode *)fromNode to: (GITGraphNode *)toNode {
    [fromNode addOutboundEdgeToNode:toNode];
    [toNode addInboundEdgeToNode:fromNode];
    edgeCounter++;
}
- (void)removeEdgeFromNode: (GITGraphNode *)fromNode to: (GITGraphNode *)toNode {
    [fromNode removeOutboundEdgeToNode:toNode];
    [toNode removeInboundEdgeToNode:fromNode];
    edgeCounter--;
}

- (GITGraphNode *)nodeWithKey: (id)key {
    return [nodes objectForKey:key];
}

- (NSUInteger)nodeCount {
    return [nodes count];
}
- (NSUInteger)edgeCount {
    return edgeCounter;
}

- (void)buildWithStartingNode: (GITGraphNode *)start {
    GITRepo *repo = [[start object] repo];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSUInteger swimmersInPool = 0;

    [self addNode:start];

    NSMutableArray *q = [[NSMutableArray alloc] initWithObjects:start, nil];
    while ( [q count] > 0 ) {
        if ( swimmersInPool++ > kMaxSwimmersInPool ) {          //!< Drain the pool
            [pool drain];
            pool = [[NSAutoreleasePool alloc] init];
            swimmersInPool = 0;
        }

        GITGraphNode *node = [[q lastObject] retain];
        [q removeLastObject];
        [node markVisited];

        NSArray *parents = [[node object] parentShas];
        for ( GITObjectHash *sha in parents ) {
            GITGraphNode *parent = [self nodeWithKey:sha];
            if ( !parent ) {
                id obj = [repo objectWithSha1:sha error:NULL];
                parent = [GITGraphNode nodeWithObject:obj key:sha];
                [self addNode:parent];
            }

            [self addEdgeFromNode:node to:parent];
            if ( ![parent visited] ) {
                [parent markVisited];
                [q addObject:parent];
            }
        }

        [node release];
    }

    [q release];
    [pool drain];
}

- (void)buildWithStartingCommit: (GITCommit *)start {
    GITGraphNode *node = [GITGraphNode nodeWithObject:start key:[start sha1]];
    return [self buildWithStartingNode:node];
}

static CFComparisonResult compareAscending(const void *a, const void *b, void *ctx) {
    GITGraphNode *x = a, *y = b;
    return (CFComparisonResult)[x compare:y];
}
static CFComparisonResult compareDescending(const void *a, const void *b, void *ctx) {
    GITGraphNode *x = a, *y = b;
    return (CFComparisonResult)[y compare:x];
}

- (NSArray *)arrayOfNodesSortedByDate {
    return nil;
}
- (NSArray *)arrayOfNodesSortedByTopology {
    return nil;
}

@end
