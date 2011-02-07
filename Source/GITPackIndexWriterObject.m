//
//  GITPackIndexWriterObject.m
//  Git.framework
//
//  Created by Geoff Garside on 06/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackIndexWriterObject.h"
#import "GITObjectHash.h"


@implementation GITPackIndexWriterObject
@synthesize sha1, offset, crc32;

+ (GITPackIndexWriterObject *)indexWriterObjectWithName: (GITObjectHash *)sha1 atOffset: (NSUInteger)offset {
    return [[[self alloc] initWithName:sha1 atOffset:offset] autorelease];
}

- (id)initWithName: (GITObjectHash *)theSha1 atOffset: (NSUInteger)theOffset {
    if ( ![super init] )
        return nil;

    self.sha1 = theSha1;
    self.offset = theOffset;

    return self;
}

- (void)dealloc {
    self.sha1 = nil;
    [super dealloc];
}

@end
