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

- (NSUInteger)hash {
    return [self.sha1 hash];
}
- (BOOL)isEqual:(id)other {
    if ( !other ) return NO;                            // other is nil
    if ( other == self ) return YES;                    // pointers match?

    if ( [other isKindOfClass:[self class]])            // Same class?
        return [self isEqualToIndexWriterObject:other];
    if ( [other isKindOfClass:[GITObjectHash class]] )  // An object hash?
        return [self isEqualToObjectHash:other];

    return NO;                                          // Definitely not then
}
- (BOOL)isEqualToIndexWriterObject: (GITPackIndexWriterObject *)rhs {
    return [self.sha1 isEqualToObjectHash:rhs.sha1];
}
- (BOOL)isEqualToObjectHash: (GITObjectHash *)rhs {
    return [self.sha1 isEqualToObjectHash:rhs];
}
- (NSComparisonResult)compare: (GITPackIndexWriterObject *)obj {
    return [self.sha1 compare:obj.sha1];
}

@end
