//
//  GITTree.m
//  Git.framework
//
//  Created by Geoff Garside on 13/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITTree.h"
#import "GITTreeItem.h"
#import "GITObjectHash.h"
#import "GITObject+Parsing.h"
#import "NSData+SHA1.h"
#import "GITError.h"


// { (char*).startPattern, (NSUI).patternLen, (NSI).startLen, (NSUI).matchLen, (char).endChar }
static parsingRecord modeParsingRecord = { "", 0, 0, 0, ' ' };
static parsingRecord nameParsingRecord = { "", 0, 0, 0, '\0' };
static parsingRecord hashParsingRecord = { "", 0, 0, 20, -1 };

@implementation GITTree

@synthesize items;

+ (NSString *)typeName {
    return [NSString stringWithString:@"tree"];
}

+ (GITObjectType)type {
    return GITObjectTypeTree;
}

+ (GITTree *)treeFromData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)repo error: (NSError **)error {
    return [[[self alloc] initFromData:data sha1:objectHash repo:repo error:error] autorelease];
}

- (id)initFromData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)theRepo error: (NSError **)error {
    if ( ![super initWithType:GITObjectTypeTag sha1:objectHash repo:theRepo] )
        return nil;

    GITObjectHash *hashVal;
    unsigned int modeVal;
    NSString *modeStr, *nameStr;

    NSScanner *scanner;
    NSMutableArray *newItems = [[NSMutableArray alloc] initWithCapacity:1];

    const char *start = [data bytes], *end = start + [data length];
    while ( start < end ) {
        if ( !(modeStr = [self newStringWithObjectRecord:modeParsingRecord bytes:&start]) ) {
            GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing mode from tree contents", @"GITObjectErrorParsingFailed"));
            [newItems release];
            [self release];
            return nil;
        }

        // Extract the mode from the string, its in hexadecimal form
        scanner = [[NSScanner alloc] initWithString:modeStr];
        if ( ![scanner scanHexInt:&modeVal] ) {
            GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing mode from tree contents", @"GITObjectErrorParsingFailed"));
            [scanner release];
            [modeStr release];
            [newItems release];
            [self release];
            return nil;
        }

        // Finished with the scanner and the mode string
        [scanner release];
        [modeStr release];
        scanner = nil;

        if ( !(nameStr = [self newStringWithObjectRecord:nameParsingRecord bytes:&start]) ) {
            GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing name from tree contents", @"GITObjectErrorParsingFailed"));
            [newItems release];
            [self release];
            return nil;
        }

        if ( !(hashVal = [self newObjectHashWithObjectRecord:hashParsingRecord bytes:&start]) ) {
            GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing sha1 from tree contents", @"GITObjectErrorParsingFailed"));
            [nameStr release];
            [newItems release];
            [self release];
            return nil;
        }

        [newItems addObject:[GITTreeItem itemInTree:self withMode:(NSUInteger)modeVal name:nameStr sha1:hashVal]];

        [hashVal release];
        [nameStr release];
        modeVal = 0;
    }

    self.items = [newItems copy];
    [newItems release];

    return self;
}

- (void)dealloc {
    self.items = nil;
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<GITTree: %p sha1=%@, items.count=%d>", self, self.sha1, [self.items count]];
}

- (NSData *)rawContentFromTreeItem: (GITTreeItem *)item {
    NSString *modeAndName = [NSString stringWithFormat:@"%06x %@", item.mode, item.name];

    size_t dataSize = 0;
    dataSize += [modeAndName length];
    dataSize += 1;                                          // NULL byte separator
    dataSize += GITObjectHashPackedLength;

    NSMutableData *rawContent = [[NSMutableData alloc] initWithCapacity:dataSize];

    [rawContent appendData:[modeAndName dataUsingEncoding:NSUTF8StringEncoding]];
    [rawContent appendBytes:"\0" length:1];                 // Append a NULL byte
    [rawContent appendData:[item.sha1 packedData]];

    NSData *data = [[rawContent copy] autorelease];
    [rawContent release];
    return data;
}

- (NSData *)rawContent {
    NSMutableData *rawContent = [[NSMutableData alloc] init];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    for ( GITTreeItem *item in self.items )
        [rawContent appendData:[self rawContentFromTreeItem:item]];

    [pool drain];

    NSData *data = [[rawContent copy] autorelease];
    [rawContent release];
    return data;
}

@end
