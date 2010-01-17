//
//  GITLooseObject.m
//  Git
//
//  Created by Geoff Garside on 14/01/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITLooseObject.h"
#import "GITObjectHash.h"
#import "GITError.h"
#import "NSData+Searching.h"
#import "NSRangeEnd.h"
#import "NSData+Compression.h"


@implementation GITLooseObject

@synthesize type, data, sha1;

+ (GITLooseObject *)looseObjectWithSha1: (GITObjectHash *)objectHash from: (NSString *)directory error: (NSError **)error {
    return [[[self alloc] initWithSha1:objectHash from:directory error:error] autorelease];
}

- (id)initWithSha1: (GITObjectHash *)objectHash from: (NSString *)directory error: (NSError **)error {
    if ( ![super init] )
        return nil;

    BOOL isDirectory;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ( ![fm fileExistsAtPath:directory isDirectory:&isDirectory] || !isDirectory ) {
        GITError(error, GITLooseObjectErrorDirectoryDoesNotExist, NSLocalizedString(@"Directory path is not a directory or does not exist", @"GITLooseObjectErrorDirectoryDoesNotExist"));
        [self release];
        return nil;
    }

    self.sha1 = objectHash;

    NSString *sha1String = [self.sha1 unpackedString];
    NSString *pathSuffix = [NSString stringWithFormat:@"%@/%@", [sha1String substringToIndex:2], [sha1String substringFromIndex:2]];
    NSString *objectPath = [directory stringByAppendingPathComponent:pathSuffix];

    if ( ![fm fileExistsAtPath:objectPath isDirectory:&isDirectory] || isDirectory ) {
        GITError(error, GITLooseObjectErrorObjectNotFound, NSLocalizedString(@"Object could not be found", @"GITLooseObjectErrorObjectNotFound"));
        [self release];
        return nil;
    }

    NSData *zlibData  = [[NSData alloc] initWithContentsOfFile:objectPath options:NSDataReadingMapped error:error];
    if ( !zlibData )    // If there was a problem reading the data...
        return nil;

    NSData *fileData  = [zlibData zlibInflate]; [zlibData release];
    NSRange typeRange = [fileData rangeFrom:0 toByte:' '];
    NSString *typeStr = [[NSString alloc] initWithBytes:[fileData bytes] length:NSRangeEnd(typeRange) encoding:NSASCIIStringEncoding];

    self.type = [GITObject objectTypeForString:typeStr];
    [typeStr release];

    NSRange prefixRange = [fileData rangeFrom:NSRangeEnd(typeRange) toByte:0x0];   // We don't care about the size
    self.data = [fileData subdataFromIndex:NSRangeEnd(prefixRange) + 1];
    [fileData release];

    return self;
}

- (void)dealloc {
    self.data = nil;
    self.sha1 = nil;
    [super dealloc];
}

- (NSUInteger)length {
    return [self.data length];
}

- (GITObject *)objectInRepo: (GITRepo *)repo error: (NSError **)error {
    return [GITObject objectOfType:self.type withData:self.data sha1:self.sha1 repo:repo error:error];
}

@end
