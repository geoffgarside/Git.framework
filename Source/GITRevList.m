//
//  GITRevList.m
//  Git.framework
//
//  Created by Geoff Garside on 11/07/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITRevList.h"
#import "GITCommit.h"
#import "GITGraph.h"
#import "GITGraphNode.h"


@implementation GITRevList

+ (GITRevList *)revListWithCommit: (GITCommit *)head {
    return [[[self alloc] initWithCommit:head] autorelease];
}

- (id)initWithCommit: (GITCommit *)head {
    if ( ![super init] )
        return nil;

    graph = [[GITGraph alloc] initWithStartingCommit:head];

    return self;
}

- (void)dealloc {
    [graph release];
    [super dealloc];
}

- (void)subtractDescendentsFromCommit: (GITCommit *)tail {
    [graph subtractDescendentNodesFromCommit:tail];
}

- (NSArray *)arrayOfCommitsSortedByDate {
    NSArray *nodes = [graph arrayOfNodesSortedByDate];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:[nodes count]];

    for ( GITGraphNode *n in nodes )
        [list addObject:[n object]];

    return [[list copy] autorelease];
}
- (NSArray *)arrayOfCommitsSortedByTopology {
    NSArray *nodes = [graph arrayOfNodesSortedByTopology];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:[nodes count]];

    for ( GITGraphNode *n in nodes )
        [list addObject:[n object]];

    return [[list copy] autorelease];
}
- (NSArray *)arrayOfCommitsSortedByTopologyAndDate {
    NSArray *nodes = [graph arrayOfNodesSortedByTopologyAndDate];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:[nodes count]];

    for ( GITGraphNode *n in nodes )
        [list addObject:[n object]];

    return [[list copy] autorelease];
}

@end
