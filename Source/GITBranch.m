//
//  GITBranch.m
//  Git
//
//  Created by Geoff Garside on 17/10/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITBranch.h"
#import "GITRepo.h"
#import "GITRef.h"
#import "GITRefResolver.h"


@implementation GITBranch

@synthesize repo, name;

+ (GITBranch *)branchWithName: (NSString *)theName inRepo: (GITRepo *)theRepo {
    return [[self class] branchFromRef:[[theRepo refResolver] resolveRefWithName:theName]];
}
+ (GITBranch *)branchFromRef: (GITRef *)theRef {
    return [[[[self class] alloc] initFromRef:theRef] autorelease];
}

- (id)initFromRef: (GITRef *)theRef {
    if ( ![super init] )
        return nil;

    self.repo = [theRef repo];
    self.name = [[theRef name] stringByReplacingOccurrencesOfString:@"refs/heads/" withString:@""];

    return self;
}

@end
