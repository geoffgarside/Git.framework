//
//  GITPackIndexVersionTwo.m
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackIndexVersionTwo.h"


@implementation GITPackIndexVersionTwo

@synthesize data;

- (NSUInteger)version {
    return 2;
}

- (id)initIndexWithData: (NSData *)indexData error: (NSError **)error {
    if ( ![super init] )
        return nil;

    self.data = indexData;

    return self;
}

- (void)dealloc {
    self.data = nil;
    
    [super dealloc];
}

@end
