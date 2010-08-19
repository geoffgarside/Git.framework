//
//  GITPackFileWriter.h
//  Git.framework
//
//  Created by Geoff Garside on 31/07/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GITPackFileWriter : NSObject {

}

//! \name Creating and Initializing PACK Writers
+ (id)packFileWriter;
+ (id)packFileWriterWithVersion: (NSUInteger)version error: (NSError **)error;
- (id)initWithVersion: (NSUInteger)version error: (NSError **)error;

- (NSUInteger)version;

@end
