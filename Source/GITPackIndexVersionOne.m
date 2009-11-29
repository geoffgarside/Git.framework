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
static const short _fanOutCount     = 256;
static const short _fanOutEnd       = 1024; //!< Size * Count
static const short _fanOutEntrySize = 24;   //!< Bytes
static const short _packedShaSize   = 20;   //!< Bytes
static const short _offsetSize      = 4;    //!< Bytes

@implementation GITPackIndexVersionOne

@synthesize data, offsets;

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

// TODO: Examine memory implications of this method
- (BOOL)parseOffsets: (NSError **)error {
    uint32_t offsetValue = 0;
    NSUInteger i, last, current;
    NSMutableArray *newOffsets = [NSMutableArray arrayWithCapacity:_fanOutCount];

    last = current = 0;
    for ( i = 0; i < _fanOutCount; i++ ) {
        [data getBytes:&offsetValue range:NSMakeRange(_fanOutSize * i, _fanOutSize)];
        current = CFSwapInt32BigToHost(offsetValue);

        if ( last > current ) {
            GITError(error, GITPackIndexErrorCorrupt, NSLocalizedString(@"PACK Index is corrupt, invalid fan out table", @"GITPackIndexErrorCorrupt"));
            return NO;
        }

        [newOffsets addObject:[NSNumber numberWithUnsignedInteger:current]];
        last = current;
    }

    self.offsets = newOffsets;
    return YES;
}

- (NSArray *)offsets: (NSError **)error {
    if ( !offsets ) {
        [self parseOffsets:error];
    }
    return offsets;
}

- (NSArray *)offsets {
    return [self offsets:NULL];
}

- (NSUInteger)indexOfPackedSha1: (uint8_t*)packedSha1 {
    return 0;
}

@end
