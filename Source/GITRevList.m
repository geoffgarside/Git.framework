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
#import "GITTree.h"
#import "GITTreeItem.h"
#import "GITTag.h"
#import "GITRepo.h"


static NSComparisonResult tagObjectsComparator(id x, id y, void *ignored);

@implementation GITRevList

+ (GITRevList *)revListWithCommit: (GITCommit *)head {
    return [[[self alloc] initWithCommit:head] autorelease];
}

- (id)initWithCommit: (GITCommit *)head {
    if ( ![super init] )
        return nil;

    repo = [[head repo] retain];
    graph = [[GITGraph alloc] initWithStartingCommit:head];

    return self;
}

- (void)dealloc {
    if ( excluded )
        [excluded release];

    [repo release];
    [graph release];
    [super dealloc];
}

- (void)subtractDescendentsFromCommit: (GITCommit *)tail {
    [graph subtractDescendentNodesFromCommit:tail];

    if ( !excluded ) excluded = [[NSMutableArray alloc] initWithCapacity:1];
    [excluded addObject:[tail tree]];
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
- (BOOL)shouldExcludeTreeItem: (GITTreeItem *)treeItem {
    for ( GITTree *t in excluded ) {
        if ( [t containsObject:treeItem] )
            return YES;
    }
    return NO;
}
- (void)addContentsOfTree: (GITTree *)tree intoArray:(NSMutableArray *)objects {
    if ( excluded && [excluded containsObject:tree] )
        return;     // The tree is excluded, so everything known to it is too

    NSArray *items = [tree items];
    [objects addObject:tree];

    for ( GITTreeItem *treeItem in items ) {
        if ( [objects containsObject:treeItem] )
            continue;

        if ( [self shouldExcludeTreeItem:treeItem] )
            continue;   // The tree item is known to the excluded tree

        [objects addObject:treeItem];
        if ( [treeItem isDirectory] && ![treeItem isModule] ) {
            [self addContentsOfTree:(GITTree *)[treeItem item] intoArray:objects];
        }
    }
}
- (NSArray *)arrayOfReachableObjectsAndTags {
    return [self arrayOfReachableObjectsAndTags:[repo tags]];
}
- (NSArray *)arrayOfReachableObjectsAndTags: (NSArray *)tags {
    NSArray *commits = [self arrayOfCommitsSortedByDate];
    NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:[commits count]]; // we should have at least as many trees

    NSMutableArray *reachableTags = nil;
    if ( tags )
        reachableTags = [[NSMutableArray alloc] initWithCapacity:[tags count]];

    for ( GITCommit *commit in commits ) {
        if ( tags ) {
            for ( GITTag *tag in tags ) {
                if ( [tag refersToObject:commit] )
                    [reachableTags addObject:tag];
            }
        }

        [self addContentsOfTree:[commit tree] intoArray:objects];
    }

    if ( tags ) {
        [reachableTags sortUsingFunction:&tagObjectsComparator context:NULL];
        [reachableTags addObjectsFromArray:objects];
        [objects release];
        objects = reachableTags;
    }

    NSArray *array = [commits arrayByAddingObjectsFromArray:objects];
    [objects release];
    return array;
}
- (NSArray *)arrayOfReachableObjects {
    return [self arrayOfReachableObjectsAndTags:nil];
}

@end

static NSComparisonResult
tagObjectsComparator(id x, id y, void *ignored) {
    (void)ignored;
    GITTag *a = (GITTag *)x, *b = (GITTag *)y;
    return [[a name] compare:[b name]];
}
