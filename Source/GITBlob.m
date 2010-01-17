//
//  GITBlob.m
//  Git.framework
//
//  Created by Geoff Garside on 13/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITBlob.h"
#import "GITObjectHash.h"
#import "NSData+SHA1.h"


@implementation GITBlob

@synthesize content;

+ (NSString *)typeName {
    return [NSString stringWithString:@"blob"];
}

+ (GITObjectType)type {
    return GITObjectTypeBlob;
}

+ (GITBlob *)blobFromData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)repo error: (NSError **)error {
    return [[[self alloc] initFromData:data sha1:objectHash repo:repo error:error] autorelease];
}

- (id)initFromData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)theRepo error: (NSError **)error {
    if ( ![super initWithType:GITObjectTypeBlob sha1:objectHash repo:theRepo] )
        return nil;

    self.content = data;
    self.size = [data length];

    return self;
}

- (void)dealloc {
    self.content = nil;
    [super dealloc];
}

@end
