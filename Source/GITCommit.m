//
//  GITCommit.m
//  Git.framework
//
//  Created by Geoff Garside on 13/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITCommit.h"
#import "GITObjectHash.h"
#import "GITObject+Parsing.h"
#import "NSData+SHA1.h"
#import "GITDateTime.h"
#import "GITActor.h"
#import "GITError.h"
#import "GITActor+Parsing.h"
#import "GITRepo.h"


// { (char*).startPattern, (NSUI).patternLen, (NSI).startLen, (NSUI).matchLen, (char).endChar}
static parsingRecord treeParsingRecord          = { "tree ", 5, 5, 40, '\n' };
static parsingRecord parentParsingRecord        = { "parent ", 7, 7, 40, '\n' };
static parsingRecord authorParsingRecord        = { "author ", 7, 7, 0, '>' };
static parsingRecord committerParsingRecord     = { "committer ", 10, 10, 0, '>' };
static parsingRecord dateParsingRecord          = { " ", 1, 1, 10, ' ' };
static parsingRecord tzParsingRecord            = { "", 0, 0, 5, '\n' };

// For parsing out the committer time in the initializer
static parsingRecord skipAuthorParsingRecord    = { "author ", 7, 7, 0, '\n' };
static parsingRecord rawDateParsingRecord       = { "committer ", 10, -17, 10, '\n' };

@interface GITCommit ()
@property (retain) GITObjectHash *treeSha1;
@property (copy) NSData *cachedData;

- (void)parseCachedData;

@end

@implementation GITCommit

@synthesize parents, tree, author, committer, authorDate, committerDate, message;
@synthesize treeSha1, parentShas, cachedData;

+ (NSString *)typeName {
    return [NSString stringWithString:@"commit"];
}

+ (GITObjectType)type {
    return GITObjectTypeCommit;
}

+ (GITCommit *)commitFromData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)repo error: (NSError **)error {
    return [[[self alloc] initFromData:data sha1:objectHash repo:repo error:error] autorelease];
}

- (id)initFromData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)theRepo error: (NSError **)error {
    if ( ![super initWithType:GITObjectTypeCommit sha1:objectHash repo:theRepo] )
        return nil;

    const char *dataBytes = [data bytes], *start = dataBytes;
    NSMutableArray *theParents = [[NSMutableArray alloc] initWithCapacity:1];  //!< 1 is the most common, but we might have more

    // Get the tree fields
    GITObjectHash *treeHash = [self newObjectHashWithObjectRecord:treeParsingRecord bytes:&dataBytes];
    if ( !treeHash ) {
        GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing tree field from commit", @"GITObjectErrorParsingFailed"));
        [theParents release];
        [self release];
        return nil;
    }
    self.treeSha1 = treeHash;
    [treeHash release];

    // Get the parent fields
    GITObjectHash *parentHash;
    while ( nil != (parentHash = [self newObjectHashWithObjectRecord:parentParsingRecord bytes:&dataBytes]) ) {
        [theParents addObject:parentHash];
        [parentHash release];
    }

    self.parentShas = [[theParents copy] autorelease];
    [theParents release];

    // We need to store the rest of the data in cachedRawData;
    NSUInteger len = [data length] - (dataBytes - start);
    NSData *cached = [[NSData alloc] initWithBytes:dataBytes length:len];
    self.cachedData = cached;
    [cached release];

    // Get the committer date information now, to help the GITGraph out
    const char *rawCommitterDate;
    parseObjectRecord(&dataBytes, skipAuthorParsingRecord, NULL, NULL);
    if ( !parseObjectRecord(&dataBytes, rawDateParsingRecord, &rawCommitterDate, NULL) ) {
        GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing committer date from commit", @"GITObjectErrorParsingFailed"));
        [self release];
        return nil;
    }
    nodeSortTimeInterval = (NSTimeInterval)strtod(rawCommitterDate, NULL);

    return self;
}

- (NSNumber *)nodeSortTimeInterval {
    return [NSNumber numberWithDouble:nodeSortTimeInterval];
}

- (void)dealloc {
    self.parents       = nil;
    self.parentShas    = nil;
    self.tree          = nil;
    self.treeSha1      = nil;
    self.author        = nil;
    self.committer     = nil;
    self.authorDate    = nil;
    self.committerDate = nil;
    self.message       = nil;
    self.cachedData    = nil;
    [super dealloc];
}

// Lazy object loaders
- (GITTree *)tree {
    if ( !tree && self.treeSha1 )
        self.tree = (GITTree *)[self.repo objectWithSha1:self.treeSha1 error:NULL];
    return tree;
}

- (NSString *)parentSha1 {
    return [self.parentShas lastObject];
}

- (GITCommit *)parent {
    return [self.parents lastObject];
}

- (NSArray *)parents {
    if ( !parents && self.parentShas ) {
        NSMutableArray *newParents = [[NSMutableArray alloc] initWithCapacity:[self.parentShas count]];
        for ( GITObjectHash *parentSha1 in self.parentShas ) {
            GITCommit *parent = (GITCommit *)[self.repo objectWithSha1:parentSha1 error:NULL];
            [newParents addObject:parent];
        }

        self.parents = newParents;
        [newParents release];
    }

    return parents;
}

// Lazily loaded properties
- (GITActor *)author {
    if ( !author )
        [self parseCachedData];
    return author;
}

- (GITActor *)committer {
    if ( !committer )
        [self parseCachedData];
    return committer;
}

- (GITDateTime *)authorDate {
    if ( !authorDate )
        [self parseCachedData];
    return authorDate;
}

- (GITDateTime *)committerDate {
    if ( !committerDate )
        [self parseCachedData];
    return committerDate;
}

- (NSString *)message {
    if ( !message )
        [self parseCachedData];
    return message;
}

- (BOOL)isMerge {
    return [[self parentShas] count] > 1;
}

- (BOOL)isInitial {
    return [[self parentShas] count] == 0;
}

// Cached Data Parsing Functions
- (GITDateTime *)parseDateTimeFromBytes: (const char **)bytes {
    const char *date;
    parseObjectRecord(bytes, dateParsingRecord, &date, NULL);
    NSTimeInterval seconds = (NSTimeInterval)strtod(date, NULL);

    NSString *tzStr = [self newStringWithObjectRecord:tzParsingRecord bytes:bytes];
    GITDateTime *dt = [GITDateTime dateTimeWithTimestamp:seconds timeZoneOffset:tzStr];

    [tzStr release];
    return dt;
}

- (void)parseCachedData {
    if ( cachedData == nil )
        return;

    const char *dataBytes = [cachedData bytes], *start = dataBytes;

    NSString *authorStr     = [self newStringWithObjectRecord:authorParsingRecord bytes:&dataBytes];
    self.author             = [GITActor actorWithParsedString:authorStr];
    [authorStr release];
    self.authorDate         = [self parseDateTimeFromBytes:&dataBytes];

    NSString *committerStr  = [self newStringWithObjectRecord:committerParsingRecord bytes:&dataBytes];
    self.committer          = [[GITActor alloc] initWithParsedString:committerStr];
    [committerStr release];
    self.committerDate      = [self parseDateTimeFromBytes:&dataBytes];

    dataBytes++;            //!< Skip over the \n between the header data and the message body
    NSUInteger messageLen   = [cachedData length] - (dataBytes - start);
    NSString *messageString = [[NSString alloc] initWithBytes:dataBytes length:messageLen encoding:NSUTF8StringEncoding];
    if ( messageString == nil )
        messageString = [[NSString alloc] initWithBytes:dataBytes length:messageLen encoding:NSASCIIStringEncoding];

    self.message            = messageString;

    [messageString release];
    self.cachedData = nil;
}

- (NSData *)rawContent {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];             // Setup a pool for convenience

    // Precompose our author and committer lines for data size calculations
    NSString *authorLine = [NSString stringWithFormat:@"author %@ %@\n", self.author, self.authorDate];
    NSString *committerLine = [NSString stringWithFormat:@"committer %@ %@\n", self.committer, self.committerDate];

    // Calculate the size of the data required
    size_t dataSize = 0;
    dataSize += 5 + GITObjectHashLength + 1;                                // tree SHA1\n
    dataSize += (7 + GITObjectHashLength + 1) * [self.parentShas count];    // parent SHA-1\n
    dataSize += [authorLine length] + [committerLine length];               // author and parent lines
    dataSize += 1;                                                          // line skip between header and message
    dataSize += [self.message length];                                      // length of the message

    // Create our data buffer, non-autoreleased so it doesn't swim in the pool.
    NSMutableData *rawContent = [[NSMutableData alloc] initWithCapacity:dataSize];
    [rawContent appendData:[[NSString stringWithFormat:@"tree %@\n", self.treeSha1] dataUsingEncoding:NSUTF8StringEncoding]];

    for ( GITObjectHash *sha in self.parentShas )                           // write parents
        [rawContent appendData:[[NSString stringWithFormat:@"parent %@\n", sha] dataUsingEncoding:NSUTF8StringEncoding]];

    [rawContent appendData:[authorLine dataUsingEncoding:NSUTF8StringEncoding]];
    [rawContent appendData:[committerLine dataUsingEncoding:NSUTF8StringEncoding]];
    [rawContent appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [rawContent appendData:[self.message dataUsingEncoding:NSUTF8StringEncoding]];

    [pool drain];                                                           // Drain the pool of objects

    NSData *data = [[rawContent copy] autorelease];                         // Create immutable copy
    [rawContent release];                                                   // Bai bai mutable :'(
    return data;
}

@end
