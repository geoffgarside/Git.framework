//
//  GITObject.m
//  Git.framework
//
//  Created by Geoff Garside on 08/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITObject.h"
#import "GITObjectHash.h"
#import "GITRepo.h"
#import "GITCommit.h"
#import "GITTree.h"
#import "GITBlob.h"
#import "GITTag.h"


@implementation GITObject

@synthesize type, sha1, repo, size;

+ (Class)objectClassForType: (GITObjectType)type {
    switch ( type ) {
        case GITObjectTypeCommit:
            return [GITCommit class];
        case GITObjectTypeTree:
            return [GITTree class];
        case GITObjectTypeBlob:
            return [GITBlob class];
        case GITObjectTypeTag:
            return [GITTag class];
    }

    return nil;
}

+ (NSString *)stringForObjectType: (GITObjectType)type {
    return [[self objectClassForType:type] typeName];
}

+ (GITObjectType)objectTypeForString: (NSString *)type {
    unsigned char fchar = [type characterAtIndex:0];
    switch ( fchar ) {
        case 'c':
            return GITObjectTypeCommit;
        case 'b':
            return GITObjectTypeBlob;
        case 't':
            if ( [type characterAtIndex:1] == 'r' )
                return GITObjectTypeTree;
            return GITObjectTypeTag;
        default:
            return GITObjectTypeUnknown;
    }
}

+ (id)objectOfType: (GITObjectType)type withData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)repo error: (NSError **)error {
    Class objectClass = [self objectClassForType:type];
    return [[[objectClass alloc] initFromData:data sha1:objectHash repo:repo error:error] autorelease];
}

- (id)initWithType: (GITObjectType)theType sha1: (GITObjectHash *)theSha1 repo: (GITRepo *)theRepo {
    if ( ![super init] )
        return nil;

    self.type = theType;
    self.sha1 = theSha1;
    self.repo = theRepo;

    return self;
}

- (id)initFromData: (NSData *)data repo: (GITRepo *)repo error: (NSError **)error {
    [self doesNotRecognizeSelector: _cmd];
    [self release];
    return nil;
}

- (void)dealloc {
    self.sha1 = nil;
    self.repo = nil;
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%s <%@>", NSStringFromClass([self class]), [self.sha1 unpackedString]];
}

- (NSUInteger)hash {
    return [sha1 hash];
}
- (BOOL)isEqual: (id)other {
    if ( !other ) return NO;                            // other is nil
    if ( other == self ) return YES;                    // pointers match?

    if ( [other isKindOfClass:[self class]] )           // Same class?
        return [self isEqualToObject:other];
    return NO;                                          // Definitely not then
}
- (BOOL)isEqualToObject: (GITObject *)rhs {
    if ( !rhs )         return NO;
    if ( self == rhs )  return YES;
    if ( type == rhs.type && [sha1 isEqualToObjectHash:[rhs sha1]] )
        return YES;
    return NO;
}

@end
