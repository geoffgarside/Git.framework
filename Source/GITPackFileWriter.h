//
//  GITPackFileWriter.h
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITPackIndexWriter;

/*!
 * A class cluster
 */
@interface GITPackFileWriter : NSObject <NSStreamDelegate> { }

+ (GITPackFileWriter *)packWriter;
+ (GITPackFileWriter *)packWriterVersion: (NSUInteger)version;

- (id)initWithDefaultVersion;
- (id)initWithVersion: (NSUInteger)version error: (NSError **)error;

- (void)writeToStream: (NSOutputStream *)stream inRunLoop: (NSRunLoop *)runLoop;
- (NSInteger)writeToStream: (NSOutputStream *)stream error: (NSError **)error;

- (GITPackIndexWriter *)indexWriter;
- (void)setIndexWriter: (GITPackIndexWriter *)indexWriter;

@end
