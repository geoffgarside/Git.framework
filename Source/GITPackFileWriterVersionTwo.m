//
//  GITPackFileWriterVersionTwo.m
//  Git.framework
//
//  Created by Geoff Garside on 31/07/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITPackFileWriterVersionTwo.h"


@implementation GITPackFileWriterVersionTwo

- (NSUInteger)version {
    return 2;
}

- (id)initWithVersion: (NSUInteger)version error: (NSError **)error {
    if ( ![super init] )
        return nil;

    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
