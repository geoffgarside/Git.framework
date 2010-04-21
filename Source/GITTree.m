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
    GITTreeItemMode modeVal;
    NSString *modeStr, *nameStr;

    NSMutableArray *newItems = [[NSMutableArray alloc] initWithCapacity:1];

    const char *start = [data bytes], *end = start + [data length];
    while ( start < end ) {
        if ( !(modeStr = [self newStringWithObjectRecord:modeParsingRecord bytes:&start]) ) {
            GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing mode from tree contents", @"GITObjectErrorParsingFailed"));
            [newItems release];
            [self release];
            return nil;
        }

        if ( !(nameStr = [self newStringWithObjectRecord:nameParsingRecord bytes:&start]) ) {
            GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing name from tree contents", @"GITObjectErrorParsingFailed"));
            [modeStr release];
            [newItems release];
            [self release];
            return nil;
        }

        if ( !(hashVal = [self newObjectHashWithObjectRecord:hashParsingRecord bytes:&start]) ) {
            GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing sha1 from tree contents", @"GITObjectErrorParsingFailed"));
            [modeStr release];
            [nameStr release];
            [newItems release];
            [self release];
            return nil;
        }

        modeVal = [modeStr integerValue];

        [newItems addObject:[GITTreeItem itemInTree:self withMode:modeVal name:nameStr sha1:hashVal]];

        [hashVal release];
        [modeStr release];
        [nameStr release];
    }

    self.items = [newItems copy];
    [newItems release];

    return self;
}

- (void)dealloc {
    self.items = nil;
    [super dealloc];
}

@end
