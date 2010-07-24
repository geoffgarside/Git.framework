//
//  GITRepo.m
//  Git.framework
//
//  Created by Geoff Garside on 14/09/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITRepo.h"
#import "GITError.h"
#import "GITRefResolver.h"
#import "GITBranch.h"
#import "GITObject.h"
#import "GITCommit.h"
#import "GITObjectHash.h"
#import "GITPackObject.h"
#import "GITLooseObject.h"
#import "GITPackCollection.h"
#import "GITCommitEnumerator.h"
#import "GITGraph.h"
#import "GITGraphNode.h"
#import "GITRevList.h"


@interface GITRepo ()
@property (copy) NSString *objectsDirectory;
@property (retain) GITPackCollection *packCollection;

- (BOOL)rootExists;
- (BOOL)rootIsAccessible;
- (BOOL)rootDoesLookSane;

@end

@implementation GITRepo

@synthesize root;
@synthesize bare;
@synthesize refResolver;
@synthesize packCollection;
@synthesize objectsDirectory;

+ (GITRepo *)repo {
    return [[[GITRepo alloc] initWithRoot:[[NSFileManager defaultManager] currentDirectoryPath] error: NULL] autorelease];
}
+ (GITRepo *)repoWithRoot: (NSString *)theRoot {
    return [[[GITRepo alloc] initWithRoot: theRoot error: NULL] autorelease];
}
+ (GITRepo *)repoWithRoot: (NSString *)theRoot error: (NSError **)theError {
    return [[[GITRepo alloc] initWithRoot: theRoot error: theError] autorelease];
}

- (id)initWithRoot: (NSString *)theRoot {
    return [self initWithRoot: theRoot error: NULL];
}
- (id)initWithRoot: (NSString *)theRoot error: (NSError **)theError {
    if ( ![super init] )
        return nil;
    
    self.root = [theRoot stringByStandardizingPath];

    if ( !(self.bare = [self.root hasSuffix:@".git"]) ) {
        self.root = [self.root stringByAppendingPathComponent:@".git"];
    }

    if ( ![self rootExists] ) {
        GITError(theError, GITRepoErrorRootDoesNotExist, NSLocalizedString(@"Path to repository does not exist", @"GITRepoErrorRootDoesNotExist"));
        [self release];
        return nil;
    }
    if ( ![self rootIsAccessible] ) {
        GITError(theError, GITRepoErrorRootNotAccessible, NSLocalizedString(@"Path to repository could not be opened, check permissions", @"GITRepoErrorRootNotAccessible"));
        [self release];
        return nil;
    }
    if ( ![self rootDoesLookSane] ) {
        GITError(theError, GITRepoErrorRootInsane, NSLocalizedString(@"Path does not appear to be a git repository", @"GITRepoErrorRootInsane"));
        [self release];
        return nil;
    }

    self.objectsDirectory = [self.root stringByAppendingPathComponent:@"objects"];
    self.packCollection = [GITPackCollection collectionWithContentsOfDirectory:[self.objectsDirectory stringByAppendingPathComponent:@"pack"] error:theError];
    if ( !packCollection ) {
        [self release];
        return nil;
    }
    
    return self;
}

- (void)dealloc {
    self.root = nil;
    self.objectsDirectory = nil;
    self.packCollection = nil;
    self.refResolver = nil;
    [super dealloc];
}

- (BOOL)rootExists {
    BOOL isDirectory;
    return [[NSFileManager defaultManager] fileExistsAtPath:self.root isDirectory:&isDirectory] && isDirectory;
}

- (BOOL)rootIsAccessible {
    return [[NSFileManager defaultManager] isReadableFileAtPath:self.root] &&
        [[NSFileManager defaultManager] isWritableFileAtPath:self.root];
}

- (BOOL)rootDoesLookSane {
    NSString *path;
    BOOL isSane = NO;
    BOOL isDirectory;

    NSFileManager *fm = [NSFileManager defaultManager];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSArray *fileChecks = [NSArray arrayWithObjects: @"HEAD", @"config", @"index", nil];
    for ( NSString *pathComponent in fileChecks ) {
        isDirectory = NO;
        path = [self.root stringByAppendingPathComponent: pathComponent];
        if ( ![fm fileExistsAtPath: path isDirectory:&isDirectory] || isDirectory )
            goto done;
    }

    NSArray *dirChecks  = [NSArray arrayWithObjects: @"refs", @"objects", nil];
    for ( NSString *pathComponent in dirChecks ) {
        isDirectory = NO;
        path = [self.root stringByAppendingPathComponent: pathComponent];
        if ( ![fm fileExistsAtPath: path isDirectory:&isDirectory] || !isDirectory )
            goto done;
    }

    isSane = YES;

done:
    [pool drain];
    return isSane;
}

- (GITRefResolver *)refResolver {
    if ( !refResolver )
        self.refResolver = [GITRefResolver resolverForRepo:self];
    return refResolver;
}

- (NSArray *)branches {
    NSArray *headRefs = [[self refResolver] headRefs];
    NSMutableArray *branches = [NSMutableArray arrayWithCapacity:[headRefs count]];

    for ( GITRef *ref in headRefs ) {
        [branches addObject:[GITBranch branchFromRef:ref]];
    }

    return [[branches copy] autorelease];
}

- (NSArray *)remoteBranches {
    NSArray *remoteRefs = [[self refResolver] remoteRefs];
    NSMutableArray *branches = [NSMutableArray arrayWithCapacity:[remoteRefs count]];

    for ( GITRef *ref in remoteRefs ) {
        [branches addObject:[GITBranch branchFromRef:ref]];
    }

    return [[branches copy] autorelease];
}

- (NSArray *)tags {
    return [[self refResolver] tagRefs];
}

- (GITObject *)objectWithSha1: (GITObjectHash *)objectHash error: (NSError **)error {
    // Need to load it from the file system
    GITLooseObject *looseObject = [GITLooseObject looseObjectWithSha1:objectHash from:self.objectsDirectory error:error];
    if ( looseObject )      // Should really return the error if it was something bad
        return [looseObject objectInRepo:self error:error];

    // Need to load it from the pack collection
    GITPackObject *packObject = [self.packCollection unpackObjectWithSha1:objectHash error:error];
    if ( !packObject )
        return nil;
    return [packObject objectInRepo:self error:error];
}

- (GITCommit *)head {
    return (GITCommit *)[[[self refResolver] resolveRefWithName:@"HEAD"] target];
}

- (GITCommitEnumerator *)enumerator {
    return [GITCommitEnumerator enumeratorFromCommit:[self head]];
}

- (GITCommitEnumerator *)enumeratorWithMode: (GITCommitEnumeratorMode)mode {
    return [GITCommitEnumerator enumeratorFromCommit:[self head] mode:mode];
}

- (GITRevList *)revList {
    return [self revListFromCommit:[self head]];
}
- (GITRevList *)revListFromCommit: (GITCommit *)head {
    return [GITRevList revListWithCommit:head];
}

- (NSArray *)revListSortedByDate {
    return [[self revList] arrayOfCommitsSortedByDate];
}
- (NSArray *)revListSortedByTopology {
    return [[self revList] arrayOfCommitsSortedByTopology];
}
- (NSArray *)revListSortedByTopologyAndDate {
    return [[self revList] arrayOfCommitsSortedByTopologyAndDate];
}

@end
