//
//  GITTreeItem.m
//  Git.framework
//
//  Created by Geoff Garside on 14/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITTreeItem.h"
#import "GITObjectHash.h"
#import "GITTree.h"
#import "GITRepo.h"


@implementation GITTreeItem

@synthesize parent, mode, name, item, sha1;

+ (GITTreeItem *)itemInTree: (GITTree *)tree withMode: (NSUInteger)mode name: (NSString *)name sha1: (GITObjectHash *)sha1 {
    return [[[self alloc] initInTree:tree withMode:mode name:name sha1:sha1] autorelease];
}

- (id)initInTree: (GITTree *)tree withMode: (NSUInteger)theMode name: (NSString *)theName sha1: (GITObjectHash *)theSha1 {
    if ( ![super init] )
        return nil;

    self.parent = tree;
    self.mode = theMode;
    self.name = theName;
    self.sha1 = theSha1;

    return self;
}

- (GITObject *)item {
    if ( !item )
        self.item = [self.parent.repo objectWithSha1:self.sha1 error:NULL];
    return item;
}

@end
