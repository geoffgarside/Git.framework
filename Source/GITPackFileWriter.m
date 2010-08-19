//
//  GITPackFileWriter.m
//  Git.framework
//
//  Created by Geoff Garside on 31/07/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITPackFileWriter.h"
#import "GITPackFileWriterPlaceholder.h"


static const NSUInteger GITPackFileWriterDefaultVersion = 2;

@implementation GITPackFileWriter

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

+ (id)packFileWriter {
    return [self packFileWriterWithVersion:GITPackFileWriterDefaultVersion error:NULL];
}

+ (id)packFileWriterWithVersion: (NSUInteger)version error: (NSError **)error {
    return [[[[self  class] alloc] initWithVersion:version error:error] autorelease];
}

- (id)initWithVersion: (NSUInteger)version error: (NSError **)error {
    [self doesNotRecognizeSelector: _cmd];
    [self release];
    return nil;
}

- (NSUInteger)version {
    return 0;
}

@end
