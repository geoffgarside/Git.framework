//
//  NSData+Searching.m
//
//  Created by Geoffrey Garside on 17/07/2008.
//  Copyright 2008 Geoffrey Garside. All rights reserved.
//

#import "NSData+Searching.h"
#import <string.h> // memchr

@implementation NSData (Searching)

- (NSRange)rangeFrom:(NSInteger)start toByte:(NSInteger)c;
{
	const char *pdata = [self bytes];
	NSUInteger len = [self length];
    if (start < len) {
        char *end = memchr(pdata + start, c, len - start);
        if (end != NULL)
            return NSMakeRange (start, end - (pdata + start));
    }
    return NSMakeRange(NSNotFound, 0);
}

- (NSRange)rangeOfNullTerminatedBytesFrom:(NSInteger)start
{
    return [self rangeFrom:start toByte:0x00];
}

- (NSData*)subdataFromIndex:(NSUInteger)anIndex
{
    NSRange theRange = NSMakeRange(anIndex, [self length] - anIndex);
    return [self subdataWithRange:theRange];
}
- (NSData*)subdataToIndex:(NSUInteger)anIndex
{
    NSRange theRange = NSMakeRange(0, anIndex);
    return [self subdataWithRange:theRange];
}

@end
