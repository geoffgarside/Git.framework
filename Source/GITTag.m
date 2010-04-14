//
//  GITTag.m
//  Git.framework
//
//  Created by Geoff Garside on 13/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITTag.h"
#import "GITRepo.h"
#import "GITObjectHash.h"
#import "GITObject+Parsing.h"
#import "NSData+SHA1.h"
#import "GITDateTime.h"
#import "GITActor.h"
#import "GITError.h"
#import "GITActor+Parsing.h"


// { (char*).startPattern, (NSUI).patternLen, (NSI).startLen, (NSUI).matchLen, (char).endChar}
static parsingRecord objectParsingRecord     = { "object ", 7, 7, 40, '\n' };
static parsingRecord typeParsingRecord       = { "type ",   5, 5, 0, '\n' };
static parsingRecord tagParsingRecord        = { "tag ",    4, 4, 0, '\n' };
static parsingRecord taggerParsingRecord     = { "tagger ", 7, 7, 0, '>' };
static parsingRecord dateParsingRecord       = { " ", 1, 1, 10, ' ' };
static parsingRecord tzParsingRecord         = { "", 0, 0, 5, '\n' };


@interface GITTag ()
@property (assign) GITObjectType  targetType;
@property (retain) GITObjectHash *targetSha1;
@property (copy) NSData *cachedData;

- (void)parseCachedData;

@end

@implementation GITTag

@synthesize name, target, tagger, taggerDate, message;
@synthesize targetType, targetSha1, cachedData;

+ (NSString *)typeName {
    return [NSString stringWithString:@"tag"];
}

+ (GITObjectType)type {
    return GITObjectTypeTag;
}

+ (GITTag *)tagFromData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)repo error: (NSError **)error {
    return [[[self alloc] initFromData:data sha1:objectHash repo:repo error:error] autorelease];
}

- (id)initFromData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)theRepo error: (NSError **)error {
    if ( ![super initWithType:GITObjectTypeTag sha1:objectHash repo:theRepo] )
        return nil;

    const char *dataBytes = [data bytes], *start = dataBytes;
    GITObjectHash *rawObjectHash = [self newObjectHashWithObjectRecord:objectParsingRecord bytes:&dataBytes];
    if ( !rawObjectHash ) {
        GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing object field from tag", @"GITObjectErrorParsingFailed"));
        [self release];
        return nil;
    }
    self.targetSha1 = rawObjectHash;
    [rawObjectHash release];

    NSString *typeString = [self newStringWithObjectRecord:typeParsingRecord bytes:&dataBytes];
    if ( !typeString ) {
        GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing type field from tag", @"GITObjectErrorParsingFailed"));
        [self release];
        return nil;
    }
    self.targetType = [[self class] objectTypeForString:typeString];
    [typeString release];

    NSString *tagString = [self newStringWithObjectRecord:tagParsingRecord bytes:&dataBytes];
    if ( !tagString ) {
        GITError(error, GITObjectErrorParsingFailed, NSLocalizedString(@"Failed parsing tag field from tag", @"GITObjectErrorParsingFailed"));
        [self release];
        return nil;
    }
    self.name = tagString;
    [tagString release];

    // We need to store the rest of the data in cachedRawData;
    NSUInteger len = [data length] - (dataBytes - start);
    NSData *cached = [[NSData alloc] initWithBytes:dataBytes length:len];
    self.cachedData = cached;
    [cached release];

    return self;
}

- (void)dealloc {
    self.name       = nil;
    self.targetSha1 = nil;
    self.target     = nil;
    [super dealloc];
}

// Lazy object loaders
- (GITObject *)target {
    if ( !target ) {
        self.target = [self.repo objectWithSha1:self.targetSha1 error:NULL];
        if ( [self.target type] != self.targetType ) {
            self.target = nil;
        }
    }

    return nil;
}

// Lazily loaded properties
- (GITActor *)tagger {
    if ( !tagger )
        [self parseCachedData];
    return tagger;
}

- (GITDateTime *)taggerDate {
    if ( !taggerDate )
        [self parseCachedData];
    return taggerDate;
}

- (NSString *)message {
    if ( !message )
        [self parseCachedData];
    return message;
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
   NSString *taggerStr     = [self newStringWithObjectRecord:taggerParsingRecord bytes:&dataBytes];
   self.tagger             = [GITActor actorWithParsedString:taggerStr];
   [taggerStr release];
   self.taggerDate         = [self parseDateTimeFromBytes:&dataBytes];

   dataBytes++;            //!< Skip over the \n between the header data and the message body
   NSUInteger messageLen   = [cachedData length] - (dataBytes - start) - 1;
   NSString *messageString = [[NSString alloc] initWithBytes:dataBytes length:messageLen encoding:NSASCIIStringEncoding];

   self.message            = messageString;

   [messageString release];
   self.cachedData = nil;
}

@end
