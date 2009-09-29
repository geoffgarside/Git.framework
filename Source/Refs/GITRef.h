//
//  GITRef.h
//  Git.framework
//
//  Created by Geoff Garside on 20/09/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITRepo;
@interface GITRef : NSObject {
    GITRepo *repo;

    NSString *name;
}

@property (retain) GITRepo *repo;
@property (copy) NSString *name;

+ (id)refWithName: (NSString *)theName inRepo: (GITRepo *)theRepo;

- (id)initWithName: (NSString *)theName inRepo: (GITRepo *)theRepo;

@end
