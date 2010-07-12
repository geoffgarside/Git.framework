//
//  GITGraphNode.m
//  Git.framework
//
//  Created by Geoff Garside on 27/04/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITGraphNode.h"


static Boolean GITGraphNodeAreEqual(const void *a, const void *b);
static CFArrayCallBacks kGITGraphNodeArrayCallbacks = {
    0, NULL, NULL, NULL, GITGraphNodeAreEqual };

@implementation GITGraphNode
@synthesize key, object, visited;

+ (GITGraphNode *)nodeWithObject: (id)object key: (id)key {
    return [[[self alloc] initWithObject:object key:key] autorelease];
}

- (id)initWithObject: (id)obj key: (id)k {
    if ( ![super init] )
        return nil;

    if ( !obj || !k ) {
        [self release];
        return nil;
    }

    key = k;
    object = obj;
    visited = NO;
    processed = NO;
    time = 0;

    if ( [object respondsToSelector:@selector(nodeSortTimeInterval)] ) {
        time = [(NSNumber*)[object performSelector:@selector(nodeSortTimeInterval)] doubleValue];
    }

    inbound = CFArrayCreateMutable(NULL, 0, &kGITGraphNodeArrayCallbacks);
    outbound = CFArrayCreateMutable(NULL, 0, &kGITGraphNodeArrayCallbacks);
    inboundEdgeCount = outboundEdgeCount = 0;

    return self;
}
- (void)dealloc {
    CFRelease(inbound);
    CFRelease(outbound);
    [key release];
    [super dealloc];
}

- (void)resetFlags {
    visited = NO;
    processed = NO;
    [self resetInboundEdgeCount];
    [self resetOutboundEdgeCount];
}

- (BOOL)hasBeenVisited {
    return visited;
}
- (void)markVisited {
    visited = NO;
}
- (BOOL)hasBeenProcessed {
    return processed;
}
- (void)markProcessed {
    processed = YES;
}

- (NSUInteger)indexOfInboundNode: (GITGraphNode *)node {
    return CFArrayGetFirstIndexOfValue(inbound,
        CFRangeMake(0, CFArrayGetCount(inbound)), node);
}
- (NSUInteger)indexOfOutboundNode: (GITGraphNode *)node {
    return CFArrayGetFirstIndexOfValue(outbound,
        CFRangeMake(0, CFArrayGetCount(outbound)), node);
}

- (void)addInboundEdgeToNode: (GITGraphNode *)node {
    if ( inboundEdgeCount > 0 && [self indexOfInboundNode:node] != -1 )
        return;

    CFArrayAppendValue(inbound, node);
    [self resetInboundEdgeCount];
}
- (void)addOutboundEdgeToNode: (GITGraphNode *)node {
    if ( outboundEdgeCount > 0 && [self indexOfOutboundNode:node] != -1 )
        return;

    CFArrayAppendValue(outbound, node);
    [self resetOutboundEdgeCount];
}

- (void)removeInboundEdgeToNode: (GITGraphNode *)node {
    CFArrayRemoveValueAtIndex(inbound, [self indexOfInboundNode:node]);
    [self resetInboundEdgeCount];
}
- (void)removeOutboundEdgeToNode: (GITGraphNode *)node {
    CFArrayRemoveValueAtIndex(outbound, [self indexOfOutboundNode:node]);
    [self resetOutboundEdgeCount];
}

- (void)resetInboundEdgeCount {
    inboundEdgeCount = CFArrayGetCount(inbound);
}
- (void)resetOutboundEdgeCount {
    outboundEdgeCount = CFArrayGetCount(outbound);
}
- (NSUInteger)inboundEdgeCount {
    return inboundEdgeCount;
}
- (NSUInteger)outboundEdgeCount {
    return outboundEdgeCount;
}
- (NSUInteger)decrementedInboundEdgeCount {
    return --inboundEdgeCount;
}
- (NSUInteger)decrementedOutboundEdgeCount {
    return --outboundEdgeCount;
}

- (NSArray *)inboundNodes {
    return [NSArray arrayWithArray: (NSMutableArray *)inbound];
}
- (NSArray *)outboundNodes {
    return [NSArray arrayWithArray: (NSMutableArray *)outbound];
}

- (NSUInteger)hash {
    return [key hash];
}
- (BOOL)isEqual: (id)other {
    return [object isEqual:[other object]];
}

- (NSTimeInterval)time {
    return time;
}
- (NSComparisonResult)compare: (GITGraphNode *)rhs {
    if ( time < [rhs time] )
        return NSOrderedAscending;
    if ( time > [rhs time] )
        return NSOrderedDescending;
    return NSOrderedSame;
}

- (NSString *)description {
    return [key description];
}

@end

static Boolean GITGraphNodeAreEqual(const void *a, const void *b) {
    return (Boolean)[(GITGraphNode *)a isEqual: (GITGraphNode *)b];
}
