//
//  GITPackReverseIndex.m
//  Git.framework
//
//  Created by Geoff Garside on 07/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackReverseIndex.h"
#import "GITPackIndex.h"


typedef struct {
    off_t offset;
    NSUInteger idx;
} GITReverseIndexEntry;

static const void* GITReverseIndexEntry_retain(CFAllocatorRef allocator, const void *ptr);
static void GITReverseIndexEntry_release(CFAllocatorRef allocator, const void *ptr);
static Boolean GITReverseIndexEntry_equal(const void *a, const void *b);
static CFComparisonResult GITReverseIndexEntry_compareOffset(const void *a, const void *b, void *context);

@implementation GITPackReverseIndex

@synthesize index;

+ (GITPackReverseIndex *)reverseIndexWithPackIndex: (GITPackIndex *)packIndex {
    return [[[self alloc] initWithPackIndex:packIndex] autorelease];
}

- (id)initWithPackIndex: (GITPackIndex *)packIndex {
    if ( ![super init] )
        return nil;

    self.index = packIndex;
    if ( ![self compileReverseIndexTable] ) {
        [self release];
        return nil;
    }

    return self;
}

- (void)dealloc {
    CFRelease(offsets), offsets = nil;
    index = nil;
    size = 0;
    [super dealloc];
}

- (BOOL)compileReverseIndexTable {
    size = [self.index numberOfObjects];

    CFArrayCallBacks offsetsCallbacks = { 0, GITReverseIndexEntry_retain, GITReverseIndexEntry_release, NULL, GITReverseIndexEntry_equal };
    CFMutableArrayRef newOffsets = CFArrayCreateMutable(kCFAllocatorDefault, size, &offsetsCallbacks);

    NSUInteger i;
    for ( i = 0; i < size; i++ ) {
        off_t packOffset = [self.index packOffsetAtIndex:i];
        GITReverseIndexEntry entry = { .offset = packOffset, .idx = i };
        CFArrayAppendValue(newOffsets, &entry);
    }

    CFArraySortValues(newOffsets, CFRangeMake(0, size), GITReverseIndexEntry_compareOffset, NULL);
    offsets = newOffsets;

    return YES;
}

- (NSUInteger)indexWithOffset: (off_t)offset {
    GITReverseIndexEntry search = { .offset = offset, .idx = 0 };
    NSUInteger result = (NSUInteger)CFArrayBSearchValues(offsets, CFRangeMake(0, size), &search, GITReverseIndexEntry_compareOffset, NULL);
    if ( !CFArrayContainsValue(offsets, CFRangeMake(result, 1), &search) )
        return NSNotFound;

    GITReverseIndexEntry *entry = (GITReverseIndexEntry *)CFArrayGetValueAtIndex(offsets, result);
    return entry->idx;
}

- (off_t)nextOffsetAfterOffset: (off_t)offset {
    GITReverseIndexEntry search = { .offset = offset, .idx = 0 };
    NSUInteger result = (NSUInteger)CFArrayBSearchValues(offsets, CFRangeMake(0, size), &search, GITReverseIndexEntry_compareOffset, NULL);

    if ( result == NSNotFound ) return NSNotFound;
    if ( result + 1 == size ) return -1;

    GITReverseIndexEntry *entry = (GITReverseIndexEntry *)CFArrayGetValueAtIndex(offsets, result + 1);
    return (off_t)entry->offset;
}

- (off_t)baseOffsetWithOffset: (off_t)offset {
    GITReverseIndexEntry search = { .offset = offset, .idx = 0 };
    NSUInteger result = (NSUInteger)CFArrayBSearchValues(offsets, CFRangeMake(0, size), &search, GITReverseIndexEntry_compareOffset, NULL);

    if ( result == NSNotFound || result >= size ) result = size - 1;
    else if ( result > 0 ) result--;

    GITReverseIndexEntry *entry = (GITReverseIndexEntry *)CFArrayGetValueAtIndex(offsets, result);
    return (off_t)entry->offset;
}

@end

static const void*
GITReverseIndexEntry_retain(CFAllocatorRef allocator, const void *ptr) {
    const GITReverseIndexEntry *rhs = ptr;
    GITReverseIndexEntry *new = (GITReverseIndexEntry *)CFAllocatorAllocate(allocator, sizeof(GITReverseIndexEntry), 0);
    new->offset = rhs->offset;
    new->idx = rhs->idx;
    return new;
}

static void
GITReverseIndexEntry_release(CFAllocatorRef allocator, const void *ptr) {
    CFAllocatorDeallocate(allocator, (GITPackReverseIndex *)ptr);
}

static Boolean
GITReverseIndexEntry_equal(const void *a, const void *b) {
    const GITReverseIndexEntry *lhs = a, *rhs = b;
    return ((off_t)lhs->offset == (off_t)rhs->offset);
}

static CFComparisonResult
GITReverseIndexEntry_compareOffset(const void *a, const void *b, void *context) {
    const GITReverseIndexEntry *this = a, *rhs = b;
    return (CFComparisonResult)((this->offset < rhs->offset) ? -1 : (this->offset > rhs->offset) ? 1 : 0);
}
