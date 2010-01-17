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
#import "GITCommit.h"


@implementation GITBranch

@synthesize repo, ref, remote;

+ (GITBranch *)branchWithName: (NSString *)theName inRepo: (GITRepo *)theRepo {
    GITRef *branchRef = [[theRepo refResolver] resolveRefWithName:theName];
    if ( !branchRef )
        return nil;
    return [[self class] branchFromRef:branchRef];
}

+ (GITBranch *)branchFromRef: (GITRef *)theRef {
    return [[[[self class] alloc] initFromRef:theRef] autorelease];
}

- (id)initFromRef: (GITRef *)theRef {
    if ( ![super init] )
        return nil;

    self.repo = [theRef repo];
    self.ref = theRef;
    self.remote = [[self.ref name] rangeOfString:@"remotes"].location != NSNotFound;

    return self;
}

- (NSString *)name {
    if ( remote )
        return [[self.ref name] stringByReplacingOccurrencesOfString:@"refs/remotes/" withString:@""];
    else
        return [[self.ref name] stringByReplacingOccurrencesOfString:@"refs/heads/" withString:@""];
}

- (void)dealloc {
    self.repo = nil;
    self.ref = nil;
    [super dealloc];
}

- (GITCommit *)head {
    return (GITCommit *)[self.ref target];
}

@end
