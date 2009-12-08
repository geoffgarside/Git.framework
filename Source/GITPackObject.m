//
//  GITPackObject.m
//  Git.framework
//
//  Created by Geoff Garside on 07/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackObject.h"
#import "NSData+DeltaPatching.h"


@implementation GITPackObject

@synthesize data, type;

+ (GITPackObject *)packObjectWithData: (NSData *)packData type: (GITObjectType)objectType {
    return [[[self alloc] initWithData:packData type:objectType] autorelease];
}

- (id)initWithData: (NSData *)packData type: (GITObjectType)objectType {
    if ( ![super init] )
        return nil;

    self.data = packData;
    self.type = objectType;

    return self;
}

- (void)dealloc {
    self.type = 0;
    self.data = nil;
    [super dealloc];
}

- (id)packObjectByDeltaPatchingWithData: (NSData *)deltaData {
    return [[self class] packObjectWithData:[self.data dataByDeltaPatchingWithData:deltaData] type:self.type];
}

@end
