//
//  GITPackIndexVersionTwo.h
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackIndex.h"


@interface GITPackIndexVersionTwo : GITPackIndex {
    NSData *data;
}

@property (copy) NSData *data;

@end
