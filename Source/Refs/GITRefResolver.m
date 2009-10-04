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
#import "NSData+Searching.h"


@interface GITRefResolver ()

- (BOOL)unpackedReferenceExistsWithName: (NSString *)theName error: (NSError **)theError;
- (BOOL)packedReferenceExistsWithName: (NSString *)theName error: (NSError **)theError;
- (BOOL)referenceExistsWithName: (NSString *)theName isPacked: (BOOL *)isPacked error: (NSError **)theError;
- (NSString *)resolvedNameOfReferenceWithName: (NSString *)theName isPacked: (BOOL *)isPacked error: (NSError **)theError;
- (NSString *)resolvedNameOfReferenceInRefs: (NSString *)theName isPacked: (BOOL *)isPacked error: (NSError **)theError;
- (NSString *)resolvedNameOfReferenceInRefsTags:(NSString *)theName isPacked:(BOOL *)isPacked error:(NSError **)theError;
- (NSString *)resolvedNameOfReferenceInRefsHeads:(NSString *)theName isPacked:(BOOL *)isPacked error:(NSError **)theError;
- (NSString *)resolvedNameOfReferenceInRefsRemotes:(NSString *)theName isPacked:(BOOL *)isPacked error:(NSError **)theError;

@end


@implementation GITRefResolver

@synthesize repo, hasPackedRefs, packedRefsCache;

+ (GITRefResolver *)resolverForRepo:(GITRepo *)theRepo {
    return [[[GITRefResolver alloc] initWithResolverForRepo:theRepo] autorelease];
}

- (id)initWithResolverForRepo: (GITRepo *)theRepo {
    if ( ![super init] )
        return nil;

    self.repo = theRepo;
    self.hasPackedRefs = NO;

    if ( [[NSFileManager defaultManager] fileExistsAtPath:[self packedRefsPath]] ) {
        self.hasPackedRefs = YES;
        self.packedRefsCache = [NSMutableDictionary dictionaryWithCapacity:1]; // odds are we'll need to look up at least one
    }

    return self;
}

- (void)dealloc {
    self.repo = nil;
    self.packedRefsCache = nil;
    [super dealloc];
}

- (NSString *)packedRefsPath {
    return [self.repo.root stringByAppendingPathComponent:@"packed-refs"];
}

- (GITRef *)resolveRefWithName: (NSString *)theName {
    return [self resolveRefWithName:theName error:NULL];
}

- (GITRef *)resolveRefWithName: (NSString *)theName error: (NSError **)theError {
    BOOL isPacked = NO;
    NSString *refName = [self resolvedNameOfReferenceWithName:theName isPacked:&isPacked error:theError];
    if ( refName ) {
        if ( isPacked ) {
            return [GITRef refWithName:refName inRepo:self.repo];
        } else {
            return [GITRef refWithName:refName inRepo:self.repo];
        }
    }
    else {
        NSString *errorDesc = [NSString stringWithFormat:NSLocalizedString(@"Could not resolve ref @%", @"GITRefResolverErrorRefNotFound"), theName];
        GITError(theError, GITRefResolverErrorRefNotFound, errorDesc);
        return nil;
    }
}

- (BOOL)unpackedReferenceExistsWithName: (NSString *)theName error: (NSError **)theError {
    BOOL isDirectory = NO;
    NSString *path = [self.repo.root stringByAppendingPathComponent:theName];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory ) {
        return YES;
    }
    return NO;
}

- (BOOL)packedReferenceExistsWithName: (NSString *)theName error: (NSError **)theError {
    if ( !self.hasPackedRefs )
        return NO;

    NSData *packedRefs = [NSData dataWithContentsOfFile:[self packedRefsPath] options:NSDataReadingMapped error:theError];
    if ( !packedRefs )
        return NO;

    NSRange rangeOfLine = [packedRefs rangeFrom:0 toByte:'\n'];
    for ( rangeOfLine; rangeOfLine.location + rangeOfLine.length < [packedRefs length];
         rangeOfLine = [packedRefs rangeFrom:rangeOfLine.location + rangeOfLine.length toByte:'\n'] ) {
        NSData *lineData = [packedRefs subdataWithRange:rangeOfLine];
        NSString *line   = [[NSString alloc] initWithData:lineData encoding:NSUTF8StringEncoding];

        if ( [line hasPrefix:@"#"] ) { // its a comment
            [line release];
            continue;
        }

        if ( ![line hasSuffix:theName] ) { // these aren't the lines we're looking for... move along
            [line release];
            continue;
        }

        // Cache the ref mapping
        [self.packedRefsCache setObject:[line copy] forKey:theName];
        [line release];
        return YES;
    }

    return NO;
}

- (BOOL)referenceExistsWithName: (NSString *)theName isPacked: (BOOL *)isPacked error: (NSError **)theError {
    if ( [self unpackedReferenceExistsWithName:theName error:theError] ) {
        *isPacked = NO;
        return YES;
    } else if ( [self packedReferenceExistsWithName:theName error:theError] ) {
        *isPacked = YES;
        return YES;
    }

    return NO;
}

- (NSString *)resolvedNameOfReferenceWithName: (NSString *)theName isPacked: (BOOL *)isPacked error: (NSError **)theError {
    NSArray *allowedReferencesInRoot = [NSArray arrayWithObjects:@"HEAD", @"FETCH_HEAD", @"ORIG_HEAD", @"MERGE_HEAD", nil];
    if ( [theName hasPrefix:@"refs/"] || [allowedReferencesInRoot containsObject:theName] ) {
        if ( [self referenceExistsWithName:theName isPacked:isPacked error:theError] ) {
            return theName;
        }
    }

    NSString *name = nil;
    if ( name = [self resolvedNameOfReferenceInRefs:theName isPacked:isPacked error:theError] )
        return name;
    if ( name = [self resolvedNameOfReferenceInRefsTags:theName isPacked:isPacked error:theError] )
        return name;
    if ( name = [self resolvedNameOfReferenceInRefsHeads:theName isPacked:isPacked error:theError] )
        return name;
    if ( name = [self resolvedNameOfReferenceInRefsRemotes:theName isPacked:isPacked error:theError] )
        return name;
    return nil;
}

- (NSString *)resolvedNameOfReferenceInRefs: (NSString *)theName isPacked: (BOOL *)isPacked error: (NSError **)theError {
    NSString *name = [@"refs/" stringByAppendingPathComponent:theName];
    if ( [self referenceExistsWithName:name isPacked:isPacked error:theError] )
        return name;
    return nil;
}

- (NSString *)resolvedNameOfReferenceInRefsTags: (NSString *)theName isPacked: (BOOL *)isPacked error: (NSError **)theError {
    NSString *name = [@"refs/tags/" stringByAppendingPathComponent:theName];
    if ( [self referenceExistsWithName:name isPacked:isPacked error:theError] )
        return name;
    return nil;
}

- (NSString *)resolvedNameOfReferenceInRefsHeads: (NSString *)theName isPacked: (BOOL *)isPacked error: (NSError **)theError {
    NSString *name = [@"refs/heads/" stringByAppendingPathComponent:theName];
    if ( [self referenceExistsWithName:name isPacked:isPacked error:theError] )
        return name;
    return nil;
}

- (NSString *)resolvedNameOfReferenceInRefsRemotes: (NSString *)theName isPacked: (BOOL *)isPacked error: (NSError **)theError {
    NSString *name = [@"refs/remotes/" stringByAppendingPathComponent:theName];
    if ( [self referenceExistsWithName:name isPacked:isPacked error:theError] )
        return name;
    return nil;
}

@end
