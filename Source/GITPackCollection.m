//
//  GITPackCollection.m
//  Git.framework
//
//  Created by Geoff Garside on 16/01/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITPackCollection.h"
#import "GITPackFile.h"
#import "GITError.h"


@interface GITPackCollection ()
@property (copy) NSArray *collection;
@property (assign) GITPackFile *recent;
@end

@implementation GITPackCollection

@synthesize collection, recent;

+ (GITPackCollection *)collectionWithContentsOfDirectory: (NSString *)directory error: (NSError **)error {
    return [[[self alloc] initWithPackFilesInDirectory:directory error:error] autorelease];
}

+ (GITPackCollection *)collectionWithPackFiles: (NSArray *)files {
    return [[[self alloc] initWithPackFiles:files] autorelease];
}

- (id)initWithPackFilesInDirectory: (NSString *)directory error: (NSError **)error {
    BOOL isDirectory;
    NSFileManager *fm = [NSFileManager defaultManager];

    // Make sure we've got a directory that exists, oh and that its a directory
    if ( ![fm fileExistsAtPath:directory isDirectory:&isDirectory] || !isDirectory ) {
        GITError(error, GITPackCollectionErrorDirectoryDoesNotExist, NSLocalizedString(@"Directory path is not a directory or does not exist", @"GITPackCollectionErrorDirectoryDoesNotExist"));
        [self release];
        return nil;
    }

    // Lets get the files
    GITPackFile *packFile;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:1];
    for ( NSString *file in [fm enumeratorAtPath:directory] ) {
        if ( ![[file pathExtension] isEqualToString:@"pack"] )
            continue;

        packFile = [GITPackFile packWithPath:[directory stringByAppendingPathComponent:file] error:error];
        if ( !packFile ) {
            [array release];
            [self release];
            return nil;
        }

        [array addObject:packFile];
    }

    id object = [self initWithPackFiles:array];
    [array release];
    return object;
}

- (id)initWithPackFiles: (NSArray *)files {
    if ( ![super init] )
        return nil;

    self.recent = nil;
    self.collection = files;
    return self;
}

- (void)dealloc {
    self.collection = nil;
    [super dealloc];
}

- (GITPackObject *)unpackObjectWithSha1: (GITObjectHash *)objectHash error: (NSError **)error {
    GITPackObject *packObject = nil;

    if ( recent ) {
        packObject = [self.recent unpackObjectWithSha1:objectHash error:error];
        if ( packObject )
            return packObject;
    }

    for ( GITPackFile *packFile in self.collection ) {
        if ( packFile == recent )
            continue;

        packObject = [packFile unpackObjectWithSha1:objectHash error:error];
        if ( packObject ) {
            self.recent = packFile;
            return packObject;
        }
    }

    return nil;
}

@end
