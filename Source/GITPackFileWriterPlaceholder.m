//
//  GITPackFileWriterPlaceholder.m
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackFileWriterPlaceholder.h"
#import "GITPackFileWriterVersionTwo.h"
#import "GITError.h"


@implementation GITPackFileWriterPlaceholder

- (id)initWithDefaultVersion {
    return [self initWithVersion:2 error:NULL];
}

- (id)initWithVersion: (NSUInteger)version error: (NSError **)error {
    NSZone *z = [self zone]; [self release];
    NSString *errDesc;

    switch ( version ) {
        case 2:
            return [[GITPackFileWriterVersionTwo allocWithZone:z] init];
        default:
            errDesc = [NSString stringWithFormat:NSLocalizedString(@"PACK file writer version %u unsupported", @"GITPackFileWriterErrorVersionUnsupported"), version];
            GITError(error, GITPackFileWriterErrorVersionUnsupported, errDesc);
            return nil;
    }
}

@end
