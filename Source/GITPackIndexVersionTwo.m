//
//  GITPackIndexVersionTwo.m
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackIndexVersionTwo.h"
#import "GITObjectHash.h"


@implementation GITPackIndexVersionTwo

@synthesize data;

- (NSUInteger)version {
    return 2;
}

- (id)initIndexWithData: (NSData *)indexData error: (NSError **)error {
    if ( ![super init] )
        return nil;

    self.data = indexData;

    return self;
}

- (void)dealloc {
    self.data = nil;
    
    [super dealloc];
}

- (NSUInteger)indexOfPackedSha1: (NSData *)packedSha {
    uint8_t *packedShaBytes = (uint8_t*)[packedSha bytes];
    uint8_t *indexDataBytes = (uint8_t*)[self.data bytes];

    NSRange rangeOfShas = [self rangeOfShasStartingWithByte:packedShaBytes[0]];
    while ( rangeOfShas.length > 0 ) {
        NSUInteger lo = rangeOfShas.location;
        NSUInteger hi = lo + rangeOfShas.length;
        NSUInteger loc = 0;    // [self rangeOfSHATable].location;

        do {
            NSUInteger mid = (lo + hi) >> 1;    // divide by 2 ;)
            NSUInteger pos = (mid * GITObjectHashPackedLength) + loc;
            int cmp = memcmp(packedShaBytes, indexDataBytes + pos, GITObjectHashPackedLength);
            if ( cmp < 0 )          { hi = mid; }
            else if ( cmp == 0 )    { return mid; }
            else                    { lo = mid + 1; }
        } while (lo < hi);
    }

    return NSNotFound;
}

@end
