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

+ (GITTree *)treeFromData: (NSData *)data repo: (GITRepo *)repo error: (NSError **)error {
    return [[[self alloc] initFromData:data repo:repo error:error] autorelease];
}

- (id)initFromData: (NSData *)data repo: (GITRepo *)theRepo error: (NSError **)error {
    if ( ![super initWithType:GITObjectTypeTag sha1:[GITObjectHash objectHashWithData:[data sha1Digest]] repo:theRepo] )
        return nil;

    GITObjectHash *hashVal;
    GITTreeItemMode modeVal;
    NSString *modeStr, *nameStr, *hashStr;

    NSMutableArray *newItems = [[NSMutableArray alloc] initWithCapacity:1];

    const char *start = [data bytes], *end = start + [data length];
    while ( start < end ) {
        if ( !(modeStr = [self createStringWithObjectRecord:modeParsingRecord bytes:&start]) ) {
            GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing mode from tree contents", @"GITObjectErrorParsingFailed"));
            [newItems release];
            [self release];
            return nil;
        }

        if ( !(nameStr = [self createStringWithObjectRecord:nameParsingRecord bytes:&start]) ) {
            GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing name from tree contents", @"GITObjectErrorParsingFailed"));
            [modeStr release];
            [newItems release];
            [self release];
            return nil;
        }

        // NSLog(@"GITTree parsing from start: %d (%p) to end: %d (%p) remaining: %d", start, start, end, end, end - start);
        if ( !(hashStr = [self createStringWithObjectRecord:hashParsingRecord bytes:&start]) ) {
            GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing sha1 from tree contents", @"GITObjectErrorParsingFailed"));
            [modeStr release];
            [nameStr release];
            [newItems release];
            [self release];
            return nil;
        }

        // NSLog(@"GITTree modeStr: '%@' nameStr: '%@' hashStr: '%@' (%d) detected", modeStr, nameStr, hashStr, [hashStr length]);

        modeVal = [modeStr integerValue];
        hashVal = [GITObjectHash objectHashWithString:hashStr];

        [newItems addObject:[GITTreeItem itemInTree:self withMode:modeVal name:nameStr sha1:hashVal]];

        [modeStr release], modeStr = nil;
        [nameStr release], nameStr = nil;
        [hashStr release], hashStr = nil;
    }

    self.items = [newItems copy];
    [newItems release];

    return self;
}

@end
