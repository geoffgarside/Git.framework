//
//  GITActor+Parsing.m
//  Git.framework
//
//  Created by Geoff Garside on 10/01/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITActor+Parsing.h"
#import "NSRangeEnd.h"


@implementation GITActor (Parsing)

+ (GITActor *)actorWithParsedString: (NSString *)str {
    return [[[self alloc] initWithParsedString:str] autorelease];
}

- (id)initWithParsedString: (NSString *)str {
    NSRange delimRange = [str rangeOfString:@" <"];
    NSString *nameChunk = [str substringToIndex:delimRange.location];
    NSString *emailChunk = [str substringFromIndex:NSRangeEnd(delimRange)];
    return [self initWithName:nameChunk email:emailChunk];
}

@end
