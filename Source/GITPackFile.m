//
//  GITPackFile.m
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackFile.h"
#import "GITPackFilePlaceholder.h"


const char const GITPackFileSignature[] = { 'P', 'A', 'C', 'K' };

@implementation GITPackFile

+ (id)alloc {
    if ([self isEqual:[GITPackFile class]])
        return [GITPackFilePlaceholder alloc];
    else return [super alloc];
}

+ (id)allocWithZone: (NSZone *)zone {
    if ([self isEqual:[GITPackFile class]])
        return [GITPackFilePlaceholder allocWithZone:zone];
    else return [super allocWithZone:zone];
}

- (id)copyWithZone: (NSZone *)zone {
    return self;
}

+ (id)packWithPath: (NSString *)packPath error: (NSError **)error {
    return [[[[self class] alloc] initWithPath:packPath error:error] autorelease];
}

- (id)initWithPath: (NSString *)packPath error: (NSError **)error {
    [self doesNotRecognizeSelector: _cmd];
    [self release];
    return nil;
}

- (id)initWithData: (NSData *)packData indexPath: (NSString *)indexPath error: (NSError **)error {
    [self doesNotRecognizeSelector: _cmd];
    [self release];
    return nil;
}

- (NSUInteger)version {
    return 0;
}

- (GITPackIndex *)index {
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSUInteger)_numberOfObjects {
    return 0;
}

- (NSUInteger)numberOfObjects {
    GITPackIndex *idx = [self index];
    return (idx ? [idx numberOfObjects] : [self _numberOfObjects]);
}

- (GITPackObject *)unpackObjectWithSha1: (GITObjectHash *)objectHash error: (NSError **)error {
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

@end
