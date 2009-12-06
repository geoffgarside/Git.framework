//
//  GITPackIndexPlaceholder.m
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackIndexPlaceholder.h"
#import "GITPackIndexVersionOne.h"
#import "GITPackIndexVersionTwo.h"
#import "GITError.h"


static const char const GITPackIndexMagicNumber[] = { '\377', 't', 'O', 'c' };
static const uint8_t const GITPackIndexVersionTwoBytes[] = { 0x0, 0x0, 0x0, 0x2 };

@implementation GITPackIndexPlaceholder

- (id)initWithPath: (NSString *)indexPath error: (NSError **)error {
    BOOL isDirectory = NO;

    if ( ![[NSFileManager defaultManager] fileExistsAtPath:indexPath isDirectory:&isDirectory] ) {
        GITError(error, GITPackIndexErrorPathNotFound, NSLocalizedString(@"Path to the PACK Index file did not exist", @"GITPackIndexErrorPathNotFound"));
        return nil;
    }

    if ( isDirectory ) {
        GITError(error, GITPackIndexErrorPathIsDirectory, NSLocalizedString(@"Path to the PACK Index file was a directory", @"GITPackIndexErrorPathIsDirectory"));
        return nil;
    }

    NSData *indexData = [NSData dataWithContentsOfFile:indexPath options:NSDataReadingMapped error:error];
    if ( !indexData )
        return nil;

    return [self initWithData:indexData error:error];
}

- (id)initWithData: (NSData *)indexData error: (NSError **)error {
    if ( !indexData )
        return nil; // No error explanation, seems a bit silly to say "Oi!! indexData was nil."

    uint32_t num, *n = &num; // to read file signature and version into
    NSZone *z = [self zone]; [self release];

    // Extract possible magic number bytes
    memset(n, 0x0, 4);
    [indexData getBytes:n range:NSMakeRange(0, 4)];

    if ( memcmp(n, GITPackIndexMagicNumber, 4) != 0 ) {
        return [[GITPackIndexVersionOne allocWithZone:z] initWithData:indexData error:error];
    }

    // Extract version for v2 and higher index files
    memset(n, 0x0, 4);
    [indexData getBytes:n range:NSMakeRange(4, 4)];

    // Version 2?
    if ( memcmp(n, GITPackIndexVersionTwoBytes, 4) == 0 ) {   // Version 2 Index file
        return [[GITPackIndexVersionTwo allocWithZone:z] initWithData:indexData error:error];
    }

    // Raise error as version not supported
    NSString *desc = [NSString stringWithFormat:NSLocalizedString(@"PACK Index version %u unsupported", @"GITPackIndexErrorVersionUnsupported"), CFSwapInt32BigToHost(num)];
    GITError(error, GITPackIndexErrorVersionUnsupported, desc);
    return nil;
}

@end
