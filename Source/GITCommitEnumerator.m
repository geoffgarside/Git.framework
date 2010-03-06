//
//  GITCommitEnumerator.m
//  Git.framework
//
//  Created by Geoff Garside on 06/02/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITCommitEnumerator.h"


@interface GITCommitEnumerator ()
@property (retain) GITCommit *head;
@property (assign) GITCommitEnumeratorMode mode;
@end

@implementation GITCommitEnumerator

@synthesize head, mode;

+ (GITCommitEnumerator *)enumeratorFromCommit: (GITCommit *)head {
    return [self enumeratorFromCommit:head mode:GITCommitEnumeratorBreadthFirstMode];
}

+ (GITCommitEnumerator *)enumeratorFromCommit: (GITCommit *)head mode: (GITCommitEnumeratorMode)mode {
    return [[[self alloc] initFromCommit:head mode:mode] autorelease];
}

- (id)initFromCommit: (GITCommit *)theHead mode: (GITCommitEnumeratorMode)theMode {
    if ( ![super init] )
        return nil;

    self.head = theHead;
    self.mode = theMode;

    return self;
}

- (void)dealloc {
    self.head = nil;
    [super dealloc];
}

@end
