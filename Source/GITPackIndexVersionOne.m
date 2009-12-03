//
//  GITPackIndexVersionOne.m
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackIndexVersionOne.h"
#import "GITObjectHash.h"
#import "GITError.h"


static const short _fanOutSize      = 4;    //!< Bytes
static const short _fanOutCount     = 256;  //!< Number of entries
static const short _fanOutEnd       = 1024; //!< Size * Count
static const short _fanOutEntrySize = 24;   //!< Bytes
static const short _offsetSize      = 4;    //!< Bytes

@implementation GITPackIndexVersionOne

@synthesize data, fanoutTable;

- (NSUInteger)version {
    return 1;
}

- (id)initWithData: (NSData *)indexData error: (NSError **)error {
    if ( ![super init] )
        return nil;
    
    self.data = indexData;
    
    return self;
}

- (void)dealloc {
    self.data = nil;

    [super dealloc];
}

- (BOOL)parseFanoutTable: (NSError **)error {
    uint32_t numberOfObjects = 0;
    NSUInteger i, last, current;
    NSMutableArray *newFanoutTable = [NSMutableArray arrayWithCapacity:_fanOutCount];

    last = current = 0;
    for ( i = 0; i < _fanOutCount; i++ ) {
        [data getBytes:&numberOfObjects range:NSMakeRange(_fanOutSize * i, _fanOutSize)];
        current = CFSwapInt32BigToHost(numberOfObjects);

        if ( last > current ) {
            GITError(error, GITPackIndexErrorCorrupt, NSLocalizedString(@"PACK Index is corrupt, invalid fan out table", @"GITPackIndexErrorCorrupt"));
            return NO;
        }

        [newFanoutTable addObject:[NSNumber numberWithUnsignedInteger:current]];
        last = current;
    }

    self.fanoutTable = [newFanoutTable copy];
    return YES;
}

/*!
 * We have to copy this from GITPackIndex as the @synthesize statement above kills it
 */
- (NSArray *)fanoutTable {
    return [self fanoutTable:NULL];
}

- (NSArray *)fanoutTable: (NSError **)error {
    if ( !fanoutTable ) {
        if ( ![self parseFanoutTable:error] )
            return nil;
    }
    return fanoutTable;
}

- (NSUInteger)indexOfSha1: (GITObjectHash *)objectHash {
    return [self indexOfPackedSha1:[objectHash packedData]];
}

- (NSUInteger)indexOfPackedSha1: (NSData *)packedSha {
    uint8_t *packedShaBytes = (uint8_t *)[packedSha bytes];
    uint8_t *indexDataBytes = (uint8_t *)[self.data bytes];

    NSRange rangeOfShas = [self rangeOfShasStartingWithByte:packedShaBytes[0]];
    if ( rangeOfShas.length > 0 ) {
        NSUInteger lo = rangeOfShas.location;
        NSUInteger hi = lo + rangeOfShas.length;
        NSUInteger loc = _fanOutEnd;

        do {
            NSUInteger mid = (lo + hi) >> 1;    // divide by 2 ;)
            NSUInteger pos = (mid * _fanOutEntrySize) + loc + _offsetSize;
            int cmp = memcmp(packedShaBytes, indexDataBytes + pos, GITObjectHashPackedLength);
            if ( cmp < 0 )          { hi = mid; }
            else if ( cmp == 0 )    { return mid; }
            else                    { lo = mid + 1; }
        } while (lo < hi);
    }

    return NSNotFound;
}

@end
