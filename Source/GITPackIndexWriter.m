//
//  GITPackIndexWriter.m
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackIndexWriter.h"
#import "GITPackIndexWriterPlaceholder.h"


@implementation GITPackIndexWriter

+ (id)alloc {
    if ([self isEqual:[GITPackIndexWriter class]])
        return [GITPackIndexWriterPlaceholder alloc];
    else return [super alloc];
}

+ (id)allocWithZone: (NSZone *)zone {
    if ([self isEqual:[GITPackIndexWriter class]])
        return [GITPackIndexWriterPlaceholder allocWithZone:zone];
    else return [super allocWithZone:zone];
}

- (id)copyWithZone: (NSZone *)zone {
    return self;
}

@end
