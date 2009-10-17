//
//  GITBranch.h
//  Git.framework
//
//  Created by Geoff Garside on 17/10/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITRepo, GITRef;
@interface GITBranch : NSObject {
    GITRepo *repo;

    NSString *name;
}

@property (retain) GITRepo *repo;
@property (copy) NSString *name;

+ (GITBranch *)branchWithName: (NSString *)theName inRepo: (GITRepo *)theRepo;
+ (GITBranch *)branchFromRef: (GITRef *)theRef;

- (id)initFromRef: (GITRef *)theRef;

@end
