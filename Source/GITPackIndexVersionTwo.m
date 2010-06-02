//
//  GITPackIndexVersionTwo.m
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackIndexVersionTwo.h"
#import "GITObjectHash.h"
#import "GITError.h"
#import "NSRangeEnd.h"


#define EXTENDED_OFFSET_FLAG (1 << 31)

static const short _fanOutStart     = 8;    //!< Bytes
static const short _fanOutSize      = 4;    //!< Bytes
static const short _fanOutCount     = 256;  //!< Number of entries
static const short _fanOutEnd       = 1032; //!< Start + (Size * Count)

static const short _crcSize         = 4;    //!< Bytes
static const short _offsetSize      = 4;    //!< Bytes
static const short _extOffsetSize   = 8;    //!< Bytes

@implementation GITPackIndexVersionTwo

@synthesize data, fanoutTable;

- (NSUInteger)version {
    return 2;
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
    NSRange fanoutRange = [self fanoutTableRange];

    last = 0;
    for ( i = 0; i < _fanOutCount; i++ ) {
        NSRange range = NSMakeRange(i * _fanOutSize + fanoutRange.location, _fanOutSize);
        [data getBytes:&numberOfObjects range:range];
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
    uint8_t *packedShaBytes = (uint8_t*)[packedSha bytes];
    uint8_t *indexDataBytes = (uint8_t*)[self.data bytes];
    NSRange shaTable = [self shaTableRange];

    GITFanoutEntry fanoutEntry = [self fanoutEntryForShasStartingWithByte:packedShaBytes[0]];
    if ( fanoutEntry.numberOfEntries > 0 ) {
        NSUInteger lo = fanoutEntry.numberOfPriorEntries;
        NSUInteger hi = lo + fanoutEntry.numberOfEntries;
        NSUInteger loc = shaTable.location;

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

- (off_t)packOffsetAtIndex: (NSUInteger)idx {
    // Get bytes for offset at position in OffsetTable
    // If bytes for offset have MSB set then parse ExtOffsetTable offset value
    NSRange offsets = [self offsetTableRange];
    NSUInteger pos  = idx * _offsetSize;

    if ( pos >= offsets.length ) {
        [NSException raise:NSRangeException format:@"PACK Index Entry %u (offset:%lu) out of bounds (%@)",
             idx, pos, NSStringFromRange(offsets)];
    }

    uint32_t offset;
    [self.data getBytes:&offset range:NSMakeRange(offsets.location + pos, _offsetSize)];

    offset = CFSwapInt32BigToHost(offset);
    if ( offset & EXTENDED_OFFSET_FLAG )
        return [self extendedPackOffsetAtOffset:offset];
    return (off_t)offset;
}

- (off_t)extendedPackOffsetAtOffset: (uint32_t)idx {
    NSRange offsets = [self extendedOffsetTableRange];
    uint32_t pos    = (idx & ~EXTENDED_OFFSET_FLAG) * _extOffsetSize;

    if ( pos >= offsets.length ) {
        [NSException raise:NSRangeException format:@"Extended PACK Index Entry from %u (offset:%lu) out of bounds (%@)",
             idx, pos, NSStringFromRange(offsets)];
    }

    uint64_t offset;
    [self.data getBytes:&offset range:NSMakeRange(offsets.location + pos, _extOffsetSize)];

    return (off_t)CFSwapInt64BigToHost(offset);
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

//! Ignore _fanoutEnd incase we stuff that up
- (NSRange)fanoutTableRange {
    return NSMakeRange(_fanOutStart, _fanOutSize * _fanOutCount);
}

- (NSRange)shaTableRange {
    NSUInteger endTable = NSRangeEnd([self fanoutTableRange]);
    return NSMakeRange(endTable, GITObjectHashPackedLength * [self numberOfObjects]);
}

- (NSRange)crcTableRange {
    NSUInteger endTable = NSRangeEnd([self shaTableRange]);
    return NSMakeRange(endTable, _crcSize * [self numberOfObjects]);
}

- (NSRange)offsetTableRange {
    NSUInteger endTable = NSRangeEnd([self crcTableRange]);
    return NSMakeRange(endTable, _offsetSize * [self numberOfObjects]);
}

- (NSRange)extendedOffsetTableRange {
    NSUInteger endTable = NSRangeEnd([self offsetTableRange]);
    NSUInteger length   = [self.data length] - endTable - (2 * GITObjectHashPackedLength);
    return NSMakeRange(endTable, length);
}

- (NSRange)packChecksumRange {
    return NSMakeRange([self.data length] - (2 * GITObjectHashPackedLength), GITObjectHashPackedLength);
}

- (NSRange)indexChecksumRange {
    return NSMakeRange([self.data length] - GITObjectHashPackedLength, GITObjectHashPackedLength);
}

@end
