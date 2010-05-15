//
//  GITObject+Parsing.m
//  Git.framework
//
//  Created by Geoff Garside on 13/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITObject+Parsing.h"
#import "GITObjectHash.h"


@implementation GITObject (Parsing)

- (GITObjectHash *)newObjectHashWithObjectRecord: (parsingRecord)record bytes:(const char **)bytes {
    const char *start;
    NSUInteger len;

    if ( !parseObjectRecord(bytes, record, &start, &len) )
        return nil;
    return [[GITObjectHash alloc] initWithBytes:start length:len];
}

- (NSString *)newStringWithObjectRecord: (parsingRecord)record bytes: (const char **)bytes {
    return [self newStringWithObjectRecord:record bytes:bytes encoding:NSUTF8StringEncoding];
}

- (NSString *)newStringWithObjectRecord: (parsingRecord)record bytes: (const char **)bytes encoding: (NSStringEncoding)encoding {
    const char *start;
    NSString *string;
    NSUInteger len;

    if ( !parseObjectRecord(bytes, record, &start, &len) )
        return nil;
    
    string = [[NSString alloc] initWithBytes:start length:len encoding:encoding];
    if ( string == nil )
        string = [[NSString alloc] initWithBytes:start length:len encoding:NSASCIIStringEncoding];

    return string;
}

@end

BOOL parseObjectRecord(const char **buffer, parsingRecord record, const char **matchStart, NSUInteger *matchLength) {
    const char *buf = *buffer;

    // If we have an initial pattern then see if we've got it
    if ( record.patternLen > 0 && memcmp(buf, record.startPattern, record.patternLen) )
        return NO;

    const char *start;                                              // Initialise start and determine start position
    if ( record.startLen > 0 ) { start = buf + record.startLen; }   // offset the buffer by the indicated start position if > 0
    else { start = buf + record.patternLen; }                       // otherwise offset by the pattern length

    const char *end = start;
    if ( (record.startLen >= 0) && (record.matchLen > 0) ) {        // If we know the length of the match, then set the end to it
        end = start + record.matchLen;
    } else {                                                        // Otherwise loop through the characters until we find endChar
        while ( *end++ != record.endChar ) { /* no-op */ }          // TODO: BRC: Add bounds checking

        if ( record.startLen < 0 ) {                                // If negative startLen, move the start pointer
            NSUInteger len = end - start;                           // Work out how far from the start the end is
            start += len + record.startLen;                         // Move the start to .startLen bytes before the end
        }

        --end;                                                      // end should point to the delimiting char
    }
    
    // check that end = endChar, otherwise there was a parsing problem
    if ( record.endChar != -1 && end[0] != record.endChar ) {
        NSLog(@"end delimiter (%c) does not match end char:%c\n", record.endChar, end[0]);
        return NO;
    }    
    
    // set matchLen
    NSUInteger matchLen = record.matchLen;
    if ( record.matchLen == 0 )
        matchLen = end - start;
    
    if ( matchStart != NULL )
        *matchStart = start;
    if ( matchLength != NULL )
        *matchLength = matchLen;
    
    *buffer = end;
    if ( record.endChar != -1 )
        *buffer += 1; // skip over the delimiting char
    return YES;
}
