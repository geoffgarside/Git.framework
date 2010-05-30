//
//  GITGraphNode.h
//  Git.framework
//
//  Created by Geoff Garside on 27/04/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GITGraphNode : NSObject {
    id key;
    id object;

    BOOL visited;
    BOOL processed;

    // Non retaining arrays
    CFMutableArrayRef inbound;
    CFMutableArrayRef outbound;

    NSUInteger inboundEdgeCount;
    NSUInteger outboundEdgeCount;

    NSTimeInterval time;
}

@property (readonly,copy) id key;
@property (readonly,assign) id object;
@property (readonly,assign) BOOL visited;

+ (GITGraphNode *)nodeWithObject: (id)object key: (id)key;

- (id)initWithObject: (id)object key: (id)key;

- (void)resetFlags;
- (BOOL)hasBeenVisited;
- (void)markVisited;
- (BOOL)hasBeenProcessed;
- (void)markProcessed;

- (void)addInboundEdgeToNode: (GITGraphNode *)node;
- (void)addOutboundEdgeToNode: (GITGraphNode *)node;

- (void)removeInboundEdgeToNode: (GITGraphNode *)node;
- (void)removeOutboundEdgeToNode: (GITGraphNode *)node;

- (void)resetInboundEdgeCount;
- (void)resetOutboundEdgeCount;
- (NSUInteger)inboundEdgeCount;
- (NSUInteger)outboundEdgeCount;
- (NSUInteger)decrementedInboundEdgeCount;
- (NSUInteger)decrementedOutboundEdgeCount;

- (NSArray *)inboundNodes;
- (NSArray *)outboundNodes;

- (BOOL)isEqual: (id)other;
- (NSComparisonResult)compare: (GITGraphNode *)rhs;

@end
