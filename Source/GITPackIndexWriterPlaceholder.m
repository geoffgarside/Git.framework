//
//  GITPackIndexWriterPlaceholder.m
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackIndexWriterPlaceholder.h"
#import "GITPackIndexWriterVersionOne.h"
#import "GITPackIndexWriterVersionTwo.h"
#import "GITError.h"


@implementation GITPackIndexWriterPlaceholder

- (id)initWithDefaultVersion {
    return [self initWithVersion:2 error:NULL];
}

- (id)initWithVersion: (NSUInteger)version error: (NSError **)error {
    NSZone *z = [self zone]; [self release];
    NSString *errDesc;

    switch ( version ) {
        case 1:
            return [[GITPackIndexWriterVersionOne allocWithZone:z] init];
        case 2:
            return [[GITPackIndexWriterVersionTwo allocWithZone:z] init];
        default:
            errDesc = [NSString stringWithFormat:NSLocalizedString(@"PACK Index writer version %u unsupported", @"GITPackIndexWriterErrorVersionUnsupported"), version];
            GITError(error, GITPackIndexWriterErrorVersionUnsupported, errDesc);
            return nil;
    }
}

@end
