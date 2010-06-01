//
//  GITPackIndex.m
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackIndex.h"
#import "GITObjectHash.h"
#import "GITPackIndexPlaceholder.h"


GITFanoutEntry GITMakeFanoutEntry(NSUInteger prior, NSUInteger entries) {
    GITFanoutEntry e;
    e.numberOfPriorEntries = prior;
    e.numberOfEntries = entries;
    return e;
}

@implementation GITPackIndex

+ (id)alloc {
    if ([self isEqual:[GITPackIndex class]])
        return [GITPackIndexPlaceholder alloc];
    else return [super alloc];
}

+ (id)allocWithZone: (NSZone *)zone {
    if ([self isEqual:[GITPackIndex class]])
        return [GITPackIndexPlaceholder allocWithZone:zone];
    else return [super allocWithZone:zone];
}

- (id)copyWithZone: (NSZone *)zone {
    return self;
}

+ (id)packIndexWithPath: (NSString *)indexPath error: (NSError **)error {
    return [[[[self class] alloc] initWithPath:indexPath error:error] autorelease];
}

- (id)initWithPath: (NSString *)indexPath error: (NSError **)error {
    [self doesNotRecognizeSelector: _cmd];
    [self release];
    return nil;
}

- (id)initWithData: (NSData *)indexData error: (NSError **)error {
    [self doesNotRecognizeSelector: _cmd];
    [self release];
    return nil;
}

- (NSUInteger)version {
    return 0;
}

- (NSArray *)fanoutTable {
    return [self fanoutTable:NULL];
}

- (NSArray *)fanoutTable: (NSError **)error {
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSUInteger)numberOfObjects {
    return [[[self fanoutTable] lastObject] unsignedIntegerValue];
}

- (GITFanoutEntry)fanoutEntryForShasStartingWithByte: (uint8_t)byte {
    NSUInteger prev = 0, curr = [[[self fanoutTable] objectAtIndex:byte] unsignedIntegerValue];
    if ( byte != 0x0 )
        prev = [[[self fanoutTable] objectAtIndex:byte - 1] unsignedIntegerValue];
    return GITMakeFanoutEntry(prev, curr - prev);
}

- (NSUInteger)indexOfSha1: (GITObjectHash *)objectHash {
    [self doesNotRecognizeSelector: _cmd];
    return 0;
}

- (off_t)packOffsetAtIndex: (NSUInteger)idx {
    [self doesNotRecognizeSelector: _cmd];
    return 0;
}

- (off_t)packOffsetForSha1: (GITObjectHash *)objectHash {
    return [self packOffsetForSha1:objectHash error:NULL];
}

- (off_t)packOffsetForSha1: (GITObjectHash *)objectHash error: (NSError **)error {
    [self doesNotRecognizeSelector: _cmd];
    return 0;
}

@end
