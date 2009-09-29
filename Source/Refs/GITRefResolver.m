//
//  GITRefResolver.m
//  Git.framework
//
//  Created by Geoff Garside on 18/09/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITRefResolver.h"
#import "GITRepo.h"
#import "GITRef.h"


@implementation GITRefResolver

@synthesize repo;

+ (GITRefResolver *)resolverForRepo:(GITRepo *)theRepo {
    return [[[GITRefResolver alloc] initWithResolverForRepo:theRepo] autorelease];
}

- (id)initWithResolverForRepo: (GITRepo *)theRepo {
    if ( ![super init] )
        return nil;

    self.repo = theRepo;

    return self;
}

- (void)dealloc {
    self.repo = nil;
    [super dealloc];
}

- (GITRef *)resolveRefWithName: (NSString *)theName {
    return [GITRef refWithName:theName inRepo:self.repo];
}

@end
