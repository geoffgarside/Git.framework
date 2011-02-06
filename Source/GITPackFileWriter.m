//
//  GITPackFileWriter.m
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackFileWriter.h"
#import "GITPackFileWriterPlaceholder.h"


@implementation GITPackFileWriter

#pragma mark Class Cluster Methods
+ (id)alloc {
    if ([self isEqual:[GITPackFileWriter class]])
        return [GITPackFileWriterPlaceholder alloc];
    else return [super alloc];
}

+ (id)allocWithZone: (NSZone *)zone {
    if ([self isEqual:[GITPackFileWriter class]])
        return [GITPackFileWriterPlaceholder allocWithZone:zone];
    else return [super allocWithZone:zone];
}

- (id)copyWithZone: (NSZone *)zone {
    return self;
}

@end
