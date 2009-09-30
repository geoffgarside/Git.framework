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
#import "GITError.h"


@interface GITRefResolver ()

- (BOOL)referenceExistsWithName:(NSString *)theName isPacked:(BOOL *)isPacked;

@end


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
    return [self resolveRefWithName:theName error:NULL];
}

- (GITRef *)resolveRefWithName: (NSString *)theName error: (NSError **)theError {
    BOOL isPacked = NO;
    if ( [self referenceExistsWithName:theName isPacked:&isPacked] )
        return [GITRef refWithName:theName inRepo:self.repo];
    else {
        NSString *errorDesc = [NSString stringWithFormat:NSLocalizedString(@"Could not resolve ref @%", @"GITRefResolverErrorRefNotFound"), theName];
        GITError(theError, GITRefResolverErrorRefNotFound, errorDesc);
        return nil;
    }
}

- (BOOL)referenceExistsWithName: (NSString *)theName isPacked: (BOOL *)isPacked {
    BOOL isDirectory = NO;
    NSString *path = [self.repo.root stringByAppendingPathComponent:theName];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory ) {
        *isPacked = NO;
        return YES;
    } else {
        // TODO: Add test for ref existence in .git/packed-refs
    }

    return NO; // could not resolve reference
}

@end
