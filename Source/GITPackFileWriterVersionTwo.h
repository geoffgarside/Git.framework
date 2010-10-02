//
//  GITPackFileWriterVersionTwo.h
//  Git.framework
//
//  Created by Geoff Garside on 31/07/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITPackFileWriter.h"


@interface GITPackFileWriterVersionTwo : GITPackFileWriter <NSStreamDelegate> {
    NSArray *objects;
}

@property (retain) NSArray *objects;

@end
