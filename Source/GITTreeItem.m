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

- (void)dealloc {
    self.parent = nil;
    self.name   = nil;
    self.sha1   = nil;
    if ( item )
        self.item = nil;

    [super dealloc];
}

- (BOOL)isLink {
    return (mode & GITTreeItemModeLink) == GITTreeItemModeLink;
}

- (BOOL)isFile {
    return (mode & GITTreeItemModeFile) == GITTreeItemModeFile;
}

- (BOOL)isDirectory {
    return (mode & GITTreeItemModeDir) == GITTreeItemModeDir;
}

- (BOOL)isModule {
    return (mode & GITTreeItemModeMod) == GITTreeItemModeMod;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<GITTreeItem: %p sha1=%@, mode=%06x, name=%@>", self, self.sha1, self.mode, self.name];
}

- (NSUInteger)hash {
    return [self.sha1 hash];
}

- (BOOL)isEqual: (id)other {
    if ( !other ) return NO;                            // other is nil
    if ( other == self ) return YES;                    // pointers match?

    if ( [other isKindOfClass:[self class]] )           // Same class?
        return [self isEqualToTreeItem:other];
    if ( [other isKindOfClass:[GITObject class]] )      // A git object?
        return [self isEqualToObject:other];

    return NO;                                          // Definitely not then
}

- (BOOL)isEqualToTreeItem: (GITTreeItem *)rhs {
    if ( !rhs )         return NO;
    if ( self == rhs )  return YES;
    if ( [self.sha1 isEqualToObjectHash:[rhs sha1]] )
        return YES;
    return NO;
}

- (BOOL)isEqualToObject: (GITObject *)rhs {
    if ( !rhs ) return NO;
    if ( [self.sha1 isEqualToObjectHash:[rhs sha1]] )
        return YES;
    return NO;
}

@end
