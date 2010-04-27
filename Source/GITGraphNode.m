//
//  GITGraphNode.m
//  Git.framework
//
//  Created by Geoff Garside on 27/04/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITGraphNode.h"


@implementation GITGraphNode
@synthesize key, object;

+ (GITGraphNode *)nodeWithObject: (id)object key: (id)key {
    return [[[self alloc] initWithObject:object key:key] autorelease];
}

- (id)initWithObject: (id)obj key: (id)k {
    if ( ![super init] )
        return nil;

    if ( !obj ) {
        [self release];
        return nil;
    }

    key = k;
    object = obj;

    return self;
}
- (void)dealloc {
    // object & key are not retained.
    [super dealloc];
}

- (NSUInteger)hash {
    return [object hash];
}
- (BOOL)isEqual: (id)other {
    return [object isEqual:other];
}

@end
