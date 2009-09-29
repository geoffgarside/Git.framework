//
//  GITRef.m
//  Git.framework
//
//  Created by Geoff Garside on 20/09/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITRef.h"


@implementation GITRef

@synthesize repo, name;

+ (id)refWithName: (NSString *)theName inRepo: (GITRepo *)theRepo {
    return [[[GITRef alloc] initWithName:theName inRepo:theRepo] autorelease];
}

- (id)initWithName:(NSString *)theName inRepo: (GITRepo *)theRepo {
    if ( ![super init] )
        return nil;

    self.repo = theRepo;
    self.name = theName;

    return self;
}

- (void)dealloc {
    self.repo = nil;
    self.name = nil;
    [super dealloc];
}

@end
