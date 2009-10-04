//
//  GITRefResolver.h
//  Git.framework
//
//  Created by Geoff Garside on 18/09/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GITRepo, GITRef;
@interface GITRefResolver : NSObject {
    GITRepo *repo;
    BOOL hasPackedRefs;
}

@property (assign) GITRepo *repo;
@property (assign) BOOL hasPackedRefs;

+ (GITRefResolver *)resolverForRepo: (GITRepo *)theRepo;

- (id)initWithResolverForRepo: (GITRepo *)theRepo;

- (GITRef *)resolveRefWithName: (NSString *)theName;
- (GITRef *)resolveRefWithName: (NSString *)theName error: (NSError **)theError;

- (NSString *)packedRefsPath;

@end
