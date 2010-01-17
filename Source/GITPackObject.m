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

@synthesize data, type, sha1;

+ (GITPackObject *)packObjectWithData: (NSData *)packData sha1: (GITObjectHash *)objectHash type: (GITObjectType)objectType {
    return [[[self alloc] initWithData:packData sha1:objectHash type:objectType] autorelease];
}

- (id)initWithData: (NSData *)packData sha1: (GITObjectHash *)objectHash type: (GITObjectType)objectType {
    if ( ![super init] )
        return nil;

    self.data = packData;
    self.type = objectType;
    self.sha1 = objectHash;

    return self;
}

- (void)dealloc {
    self.type = 0;
    self.data = nil;
    self.sha1 = nil;
    [super dealloc];
}

- (id)packObjectByDeltaPatchingWithData: (NSData *)deltaData {
    return [[self class] packObjectWithData:[self.data dataByDeltaPatchingWithData:deltaData] sha1:self.sha1 type:self.type];
}

- (NSUInteger)length {
    return [self.data length];
}

- (GITObject *)objectInRepo: (GITRepo *)repo error: (NSError **)error {
    return [GITObject objectOfType:self.type withData:self.data sha1:self.sha1 repo:repo error:error];
}

@end
