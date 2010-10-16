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

- (NSData *)dataForHeadFile;
- (NSData *)dataForConfigFile;
- (NSData *)dataForDescriptionFile;
- (NSData *)dataForInfoExcludeFile;
- (NSArray *)arrayOfSkeletonDirectories;
- (BOOL)createDirectorySkeletonAtPath: (NSString *)theRoot error: (NSError **)theError;

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
+ (GITRepo *)createRepoAtPath: (NSString *)path {
    return [[[GITRepo alloc] initAtPath: path error: NULL] autorelease];
}
+ (GITRepo *)createRepoAtPath: (NSString *)path error: (NSError **)theError {
    return [[[GITRepo alloc] initAtPath: path error: theError] autorelease];
}

- (id)initAtPath: (NSString *)path {
    return [self initAtPath: path error: NULL];
}
- (id)initAtPath: (NSString *)path error: (NSError **)theError {
    if ( ![self createDirectorySkeletonAtPath:path error:theError] )
        return nil;
    return [self initWithRoot:path error:theError];
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

#pragma mark Creating Skeleton
- (NSData *)dataForHeadFile {
    return [[NSString stringWithString:@"ref: refs/heads/master\n"] dataUsingEncoding:NSASCIIStringEncoding];
}
- (NSData *)dataForConfigFile {
    NSString *str = [NSString stringWithString:@"[core]\n  repositoryformatversion = 0\n  filemode = true\n  bare = false\n  logallrefupdates = true\n  ignorecase = true\n"];
    return [str dataUsingEncoding:NSASCIIStringEncoding];
}
- (NSData *)dataForDescriptionFile {
    return [[NSString stringWithString:@"Unnamed repository; edit this file 'description' to name the repository.\n"] dataUsingEncoding:NSASCIIStringEncoding];
}
- (NSData *)dataForInfoExcludeFile {
    NSString *str = [NSString stringWithString:@"# git ls-files --others --exclude-from=.git/info/exclude\n# Lines that start with '#' are comments.\n# For a project mostly in C, the following would be a good set of\n# exclude patterns (uncomment them if you want to use them):\n# *.[oa]\n# *~\n"];
    return [str dataUsingEncoding:NSASCIIStringEncoding];

}
- (NSArray *)arrayOfSkeletonDirectories {
    return [NSArray arrayWithObjects:@"branches", @"hooks", @"info", @"objects/info", @"objects/pack", @"refs/heads", @"refs/tags", nil];
}
- (BOOL)createDirectorySkeletonAtPath: (NSString *)path error: (NSError **)theError {
    NSFileManager *fm = [[NSFileManager alloc] init];

    NSString *gitRoot;
    if ( [path hasSuffix:@".git"] ) {
        gitRoot = [path copy];
    } else {
        gitRoot = [path stringByAppendingPathComponent:@".git"];
    }

    if ( [fm fileExistsAtPath:gitRoot] ) {
        GITError(theError, GITRepoErrorSkeletonExists, NSLocalizedString(@"Directory for skeleton exists", @"GITRepoErrorSkeletonExists"));
        return NO;
    }

    NSError *directoryError;
    for ( NSString *dir in [self arrayOfSkeletonDirectories] ) {
        if ( ![fm createDirectoryAtPath:[gitRoot stringByAppendingPathComponent:dir]
                withIntermediateDirectories:YES attributes:nil error:&directoryError] ) {
            GITErrorWithInfo(theError, GITRepoErrorSkeletonCreationFailed, NSUnderlyingErrorKey, directoryError,
                             NSLocalizedDescriptionKey, NSLocalizedString(@"Failed to create skeleton directory", @"GITRepoErrorCreationFailed directory"), nil);
            goto cleanup;
        }
    }

    if ( ![fm createFileAtPath:[gitRoot stringByAppendingPathComponent:@"HEAD"]
                      contents:[self dataForHeadFile] attributes:nil] ) {
        GITError(theError, GITRepoErrorSkeletonCreationFailed, NSLocalizedString(@"Failed to create HEAD file", @"GITRepoErrorCreationFailed HEAD file"));
        goto cleanup;
    }

    if ( ![fm createFileAtPath:[gitRoot stringByAppendingPathComponent:@"config"]
                      contents:[self dataForConfigFile] attributes:nil] ) {
        GITError(theError, GITRepoErrorSkeletonCreationFailed, NSLocalizedString(@"Failed to create config file", @"GITRepoErrorCreationFailed config file"));
        goto cleanup;
    }

    if ( ![fm createFileAtPath:[gitRoot stringByAppendingPathComponent:@"description"]
                      contents:[self dataForDescriptionFile] attributes:nil] ) {
        GITError(theError, GITRepoErrorSkeletonCreationFailed, NSLocalizedString(@"Failed to create description file", @"GITRepoErrorCreationFailed description file"));
        goto cleanup;
    }

    if ( ![fm createFileAtPath:[gitRoot stringByAppendingPathComponent:@"info/exclude"]
                      contents:[self dataForInfoExcludeFile] attributes:nil] ) {
        GITError(theError, GITRepoErrorSkeletonCreationFailed, NSLocalizedString(@"Failed to create info/exclude file", @"GITRepoErrorCreationFailed info/exclude file"));
        goto cleanup;
    }

    [fm release];
    return YES;

cleanup:
    [fm removeItemAtPath:gitRoot error:NULL];
    [fm release];
    return NO;
}

@end
