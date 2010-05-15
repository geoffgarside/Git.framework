//
//  GITGraphNode.m
//  Git.framework
//
//  Created by Geoff Garside on 27/04/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITGraphNode.h"
#import "GITDateTime.h"
#import "GITCommit.h"


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

    if ( [object respondsToSelector:@selector(committerDate)] ) {
        GITDateTime *dateTime = [object committerDate];
        time = [[dateTime date] timeIntervalSinceReferenceDate];
    }

    inbound = CFArrayCreateMutable(NULL, 0, &kGITGraphNodeArrayCallbacks);
    outbound = CFArrayCreateMutable(NULL, 0, &kGITGraphNodeArrayCallbacks);

    return self;
}
- (void)dealloc {
    [key release];
    [super dealloc];
}

- (void)resetFlags {
    visited = NO;
    processed = NO;
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

- (void)addInboundEdgeToNode: (GITGraphNode *)node {
    CFArrayAppendValue(inbound, node);
}
- (void)addOutboundEdgeToNode: (GITGraphNode *)node {
    CFArrayAppendValue(outbound, node);
}

- (void)removeInboundEdgeToNode: (GITGraphNode *)node {
    NSUInteger i = CFArrayGetFirstIndexOfValue(inbound,
        CFRangeMake(0, CFArrayGetCount(inbound)), node);
    CFArrayRemoveValueAtIndex(inbound, i);
}
- (void)removeOutboundEdgeToNode: (GITGraphNode *)node {
    NSUInteger i = CFArrayGetFirstIndexOfValue(outbound,
        CFRangeMake(0, CFArrayGetCount(outbound)), node);
    CFArrayRemoveValueAtIndex(outbound, i);
}

- (NSUInteger)inboundEdgeCount {
    return CFArrayGetCount(inbound);
}
- (NSUInteger)outboundEdgeCount {
    return CFArrayGetCount(outbound);
}

- (NSArray *)inboundNodes {
    return [NSArray arrayWithArray: (NSMutableArray *)inbound];
}
- (NSArray *)outboundNodes {
    return [NSArray arrayWithArray: (NSMutableArray *)outbound];
}

- (NSUInteger)hash {
    return [object hash];
}
- (BOOL)isEqual: (id)other {
    return [object isEqual:other];
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

@end

static Boolean GITGraphNodeAreEqual(const void *a, const void *b) {
    return (Boolean)[(GITGraphNode *)a isEqual: (GITGraphNode *)b];
}
