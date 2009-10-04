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

@interface GITRepo ()

@property (retain) GITRefResolver *refResolver;

- (BOOL)rootExists;
- (BOOL)rootIsAccessible;
- (BOOL)rootDoesLookSane;

@end

@implementation GITRepo

@synthesize root;
@synthesize bare;
@synthesize refResolver;

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
    
    return self;
}

- (void)dealloc {
    self.root = nil;
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

@end
