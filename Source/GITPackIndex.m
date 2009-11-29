//
//  GITPackIndex.m
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackIndex.h"
#import "GITPackIndexPlaceholder.h"


@implementation GITPackIndex

+ (id)alloc {
    if ([self isEqual:[GITPackIndex class]])
        return [GITPackIndexPlaceholder alloc];
    else return [super alloc];
}

+ (id)allocWithZone: (NSZone *)zone {
    if ([self isEqual:[GITPackIndex class]])
        return [GITPackIndexPlaceholder allocWithZone:zone];
    else return [super allocWithZone:zone];
}

- (id)copyWithZone: (NSZone *)zone {
    return self;
}

+ (id)packIndexWithPath: (NSString *)indexPath error: (NSError **)error {
    return [[[[self class] alloc] initWithPath:indexPath error:error] autorelease];
}

- (id)initWithPath: (NSString *)indexPath error: (NSError **)error {
    [self doesNotRecognizeSelector: _cmd];
    [self release];
    return nil;
}

- (id)initWithData: (NSData *)indexData error: (NSError **)error {
    [self doesNotRecognizeSelector: _cmd];
    [self release];
    return nil;
}

- (NSUInteger)version {
    return 0;
}

@end
