//
//  GITGraph.h
//  Git.framework
//
//  Created by Geoff Garside on 26/04/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITGraphNode, GITCommit;
@interface GITGraph : NSObject {
    NSMutableDictionary *nodes;
    NSUInteger edgeCounter;
}

+ (GITGraph *)graph;
+ (GITGraph *)graphWithStartingCommit: (GITCommit *)commit;

- (id)init;
- (id)initWithStartingCommit: (GITCommit *)commit;

- (BOOL)hasNode: (GITGraphNode *)node;
- (void)addNode: (GITGraphNode *)node;
- (void)removeNode: (GITGraphNode *)node;
- (void)addEdgeFromNode: (GITGraphNode *)fromNode to: (GITGraphNode *)toNode;
- (void)removeEdgeFromNode: (GITGraphNode *)fromNode to: (GITGraphNode *)toNode;

- (GITGraphNode *)nodeWithKey: (id)key;

- (NSUInteger)nodeCount;
- (NSUInteger)edgeCount;

- (void)buildWithStartingCommit: (GITCommit *)commit;

- (NSArray *)arrayOfNodesSortedByDate;
- (NSArray *)arrayOfNodesSortedByTopology;

@end
