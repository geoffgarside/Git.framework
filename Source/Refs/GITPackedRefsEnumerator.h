//
//  GITPackedRefsEnumerator.h
//  Git.framework
//
//  Created by Geoff Garside on 04/10/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/NSEnumerator.h>

@class NSData, NSString, GITRepo;
@interface GITPackedRefsEnumerator : NSEnumerator {
    NSString *packedRefsPath;
    BOOL hasPackedRefs;
    BOOL started;

    NSData *packedRefs;
    NSRange currentRange;
}

+ (GITPackedRefsEnumerator *)enumeratorForRepo: (GITRepo *)theRepo;
- (id)initWithRepo: (GITRepo *)theRepo;

@end
