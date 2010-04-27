//
//  GITGraph.m
//  Git.framework
//
//  Created by Geoff Garside on 26/04/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITGraph.h"
#import "GITGraphNode.h"
#import "GITCommit.h"
#import "GITObjectHash.h"
#import "GITCommitEnumerator.h"


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
    // Add node
    edgeCounter++;
}
- (void)removeEdgeFromNode: (GITGraphNode *)fromNode to: (GITGraphNode *)toNode {
    // Remove node
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

- (void)buildWithStartingCommit: (GITCommit *)start {
    // do stuff to build graph
    GITCommitEnumerator *enumerator = [[GITCommitEnumerator alloc] initWithCommit:start mode:GITCommitEnumeratorDepthFirstMode];
    GITGraphNode *node = nil, *last = nil, *parent = nil;
    GITCommit *commit = nil;

    while ( commit = [enumerator nextObject] ) {
        // do something
        node = [GITGraphNode nodeWithObject:commit key:[commit sha1]];
        [self addNode:node];

        for ( GITObjectHash *sha1 in [commit parentShas] ) {
            parent = [self nodeWithKey:sha1];
        }

        last = node;
    }

    [enumerator release];
}

- (NSArray *)arrayOfNodesSortedByDate {
    return nil;
}
- (NSArray *)arrayOfNodesSortedByTopology {
    return nil;
}

@end
