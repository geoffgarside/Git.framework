//
//  GITPackFileWriterPlaceholder.m
//  Git.framework
//
//  Created by Geoff Garside on 31/07/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITPackFileWriterPlaceholder.h"
#import "GITPackFileWriterVersionTwo.h"


@implementation GITPackFileWriterPlaceholder

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
