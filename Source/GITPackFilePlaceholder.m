//
//  GITPackFilePlaceholder.m
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackFilePlaceholder.h"
#import "GITPackFileVersionTwo.h"
#import "GITError.h"


@implementation GITPackFilePlaceholder

- (id)initWithPath: (NSString *)packPath error: (NSError **)error {
    BOOL isDirectory = NO;

    if ( ![[NSFileManager defaultManager] fileExistsAtPath:packPath isDirectory:&isDirectory] ) {
        GITError(error, GITPackFileErrorPathNotFound, NSLocalizedString(@"Path to the PACK file did not exist", @"GITPackFileErrorPathNotFound"));
        return nil;
    }

    if ( isDirectory ) {
        GITError(error, GITPackFileErrorPathIsDirectory, NSLocalizedString(@"Path to the PACK file was a directory", @"GITPackFileErrorPathIsDirectory"));
        return nil;
    }

    NSData *packData = [NSData dataWithContentsOfFile:packPath options:NSDataReadingMapped error:error];
    if ( !packData )
        return nil;

    return [self initWithData:packData indexPath:[[packPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"idx"] error:error];
}

- (id)initWithData: (NSData *)packData indexPath: (NSString *)indexPath error: (NSError **)error {
    if ( !packData )
        return nil; // No error explanation, seems a bit silly to say "Oi!! packData was nil."
    
    uint32_t num, *n = &num; // to read file signature and version into
    NSZone *z = [self zone]; [self release];
    
    // Extract signature bytes
    memset(n, 0x0, 4);
    [packData getBytes:n range:NSMakeRange(0, 4)];
    
    if ( memcmp(n, GITPackFileSignature, 4) != 0 ) { // signature doesn't match, not a pack file
        GITError(error, GITPackFileErrorFileIsInvalid, NSLocalizedString(@"PACK Data is missing signature", @"GITPackFileErrorFileIsInvalid"));
        return nil;
    }
    
    // Extract version bytes
    memset(n, 0x0, 4);
    [packData getBytes:n range:NSMakeRange(4, 4)];
    
    // Initialise version specific class
    if ( memcmp(n, GITPackFileVersionTwoVersionBytes, 4) == 0 ) { // Version 2 PACK file
        return [[GITPackFileVersionTwo allocWithZone:z] initWithData:packData indexPath:indexPath error:error];
    }
    
    // Raise error as version not supported
    NSString *desc = [NSString stringWithFormat:NSLocalizedString(@"PACK file version %u unsupported", @"GITPackFileErrorVersionUnsupported"), CFSwapInt32BigToHost(num)];
    GITError(error, GITPackFileErrorVersionUnsupported, desc);
    return nil;
}

@end
