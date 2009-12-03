//
//  GITPackIndexVersionOne.m
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackIndexVersionOne.h"
#import "GITError.h"


static const short _fanOutSize      = 4;    //!< Bytes
static const short _fanOutCount     = 256;  //!< Number of entries
static const short _fanOutEnd       = 1024; //!< Size * Count
static const short _fanOutEntrySize = 24;   //!< Bytes
static const short _packedShaSize   = 20;   //!< Bytes
static const short _offsetSize      = 4;    //!< Bytes

@implementation GITPackIndexVersionOne

@synthesize data, fanoutTable;

- (NSUInteger)version {
    return 1;
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

@end
