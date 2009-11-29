//
//  GITPackFileVersionTwo.h
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackFile.h"


@class GITPackIndex;
@interface GITPackFileVersionTwo : GITPackFile {
    NSData *data;
    GITPackIndex *index;
}

@property (copy) NSData *data;
@property (retain) GITPackIndex *index;

@end
