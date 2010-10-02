//
//  GITPackFileWriterVersionTwo.m
//  Git.framework
//
//  Created by Geoff Garside on 31/07/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#include <CommonCrypto/CommonDigest.h>
#import "GITPackFileWriterVersionTwo.h"
#import "GITPackFileVersionTwo.h"
#import "GITRevList.h"
#import "GITObject.h"
#import "GITCommit.h"
#import "GITObjectHash.h"
#import "NSData+SHA1.h"
#import "GITRepo.h"


@implementation GITPackFileWriterVersionTwo

@synthesize objects;

- (NSUInteger)version {
    return 2;
}

- (id)initWithVersion: (NSUInteger)version error: (NSError **)error {
    if ( ![super init] )
        return nil;

    return self;
}

- (void)dealloc {
    self.objects = nil;

    [super dealloc];
}

// Objects are written such that
// - all commits in recency order
// - all tags in recency order
// - trees and blobs in recency order, trees then their contents
- (void)addObjectsFromCommit: (GITCommit *)commit {
    GITRevList *revList = [GITRevList revListWithCommit:commit];
    if ( !objects ) {
        self.objects = [revList arrayOfReachableObjectsAndTags:[[commit repo] tags]];
    } else {
        // Need to merge the [revList arrayOfReachableObjects] into self.objects
    }
}

- (NSArray *)sortedObjectNames {
    NSMutableArray *shas = [[NSMutableArray alloc] initWithCapacity:[self.objects count]];
    for ( id obj in self.objects )
        [shas addObject:[obj sha1]];

    NSArray *sortedShas = [shas sortedArrayUsingSelector:@selector(compare:)];
    [shas release];
    return sortedShas;
}

- (NSString *)sha1StringOfPackedObjectNames {
    NSArray *sortedShas = [self sortedObjectNames];

    NSMutableData *shaData = [[NSMutableData alloc] initWithCapacity:[sortedShas count] * GITObjectHashPackedLength];
    for ( GITObjectHash *sha in sortedShas )
        [shaData appendData:[sha packedData]];

    NSString *str = [shaData sha1DigestString];
    [shaData release];
    return str;
}

- (NSString *)fileName {
    return [NSString stringWithFormat:@"pack-%@.pack", [self sha1StringOfPackedObjectNames]];
}

@end
