//
//  GITPackIndexVersionOne.h
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackIndex.h"


@interface GITPackIndexVersionOne : GITPackIndex {
    NSData *data;
    NSArray *offsets;
}

@property (copy) NSData *data;
@property (copy) NSArray *offsets;

- (NSArray *)offsets: (NSError **)error;

@end
