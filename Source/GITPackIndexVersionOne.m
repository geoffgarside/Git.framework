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
static const short _indexEntrySize  = 24;   //!< Bytes
static const short _offsetSize      = 4;    //!< Bytes

typedef struct {
    uint32_t offset;
    uint8_t sha[20];
} GITPackIndexEntry;

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
    self.fanoutTable = nil;

    [super dealloc];
}

- (BOOL)parseFanoutTable: (NSError **)error {
    uint32_t numberOfObjects = 0;
    NSUInteger i, last, current;
    NSMutableArray *newFanoutTable = [NSMutableArray arrayWithCapacity:_fanOutCount];

    last = 0;
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
    const uint8_t *packedShaBytes = (uint8_t *)[packedSha bytes];
    const uint8_t *indexDataBytes = (uint8_t *)[self.data bytes];

    GITFanoutEntry fanoutEntry = [self fanoutEntryForShasStartingWithByte:packedShaBytes[0]];
    if ( fanoutEntry.numberOfEntries > 0 ) {
        NSUInteger lo = fanoutEntry.numberOfPriorEntries;
        NSUInteger hi = lo + fanoutEntry.numberOfEntries;
        NSUInteger loc = _fanOutEnd;

        do {
            NSUInteger mid = (lo + hi) >> 1;    // divide by 2 ;)
            NSUInteger pos = (mid * _indexEntrySize) + loc + _offsetSize;
            int cmp = memcmp(packedShaBytes, indexDataBytes + pos, GITObjectHashPackedLength);
            if ( cmp < 0 )          { hi = mid; }
            else if ( cmp == 0 )    { return mid; }
            else                    { lo = mid + 1; }
        } while (lo < hi);
    }

    return NSNotFound;
}

- (GITPackIndexEntry *)extractIndexEntryAtIndex: (NSUInteger)idx into: (GITPackIndexEntry *)entry {
    NSRange index  = [self indexTableRange];
    NSUInteger pos = idx * _indexEntrySize;

    if ( pos >= index.length ) {
        [NSException raise:NSRangeException format:@"PACK Index Entry %u (offset:%lu) out of bounds (%@)",
             idx, pos, NSStringFromRange(index)];
    }

    [self.data getBytes:entry range:NSMakeRange(index.location + pos, _indexEntrySize)];
    return entry;
}

- (off_t)packOffsetAtIndex: (NSUInteger)idx {
    GITPackIndexEntry entry;
    [self extractIndexEntryAtIndex:idx into:&entry];
    return (off_t)CFSwapInt32BigToHost(entry.offset);
}

- (off_t)packOffsetForSha1: (GITObjectHash *)objectHash error: (NSError **)error {
    return [self packOffsetForPackedSha1:[objectHash packedData] error:error];
}

- (off_t)packOffsetForPackedSha1: (NSData *)packedSha error: (NSError **)error {
    NSUInteger idx = [self indexOfPackedSha1:packedSha];
    if ( idx != NSNotFound )
        return [self packOffsetAtIndex:idx];

    GITError(error, GITPackErrorObjectNotFound, NSLocalizedStringWithArguments(@"Object <%@> not found in PACK Index file", @"GITPackErrorObjectNotFound", [GITObjectHash unpackedStringFromData:packedSha]));
    return NSNotFound;
}

- (NSRange)fanoutTableRange {
    return NSMakeRange(0, _fanOutEnd);
}

- (NSRange)indexTableRange {
    NSRange fanout = [self fanoutTableRange];
    NSRange chksum = [self packChecksumRange];
    NSUInteger loc = fanout.location + fanout.length;
    return NSMakeRange(loc, chksum.location - loc);
}

- (NSRange)packChecksumRange {
    return NSMakeRange([self.data length] - (2 * GITObjectHashPackedLength), GITObjectHashPackedLength);
}

- (NSRange)indexChecksumRange {
    return NSMakeRange([self.data length] - GITObjectHashPackedLength, GITObjectHashPackedLength);
}

@end
