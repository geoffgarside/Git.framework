//
//  GITRef.m
//  Git.framework
//
//  Created by Geoff Garside on 20/09/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITRef.h"
#import "GITRepo.h"
#import "GITRefResolver.h"
#import "GITObjectHash.h"


@implementation GITRef

@synthesize repo, name, link, targetName;

+ (id)refWithName: (NSString *)theName andTarget: (NSString *)theTarget inRepo: (GITRepo *)theRepo {
    return [[[GITRef alloc] initWithName:theName andTarget:theTarget inRepo:theRepo] autorelease];
}

- (id)initWithName:(NSString *)theName andTarget: (NSString *)theTarget inRepo: (GITRepo *)theRepo {
    if ( ![super init] )
        return nil;

    self.repo = theRepo;
    self.name = theName;
    self.targetName = theTarget;
    self.link = NO;

    if ( [self.targetName hasPrefix:@"ref: "] )
        self.link = YES;

    return self;
}

- (void)dealloc {
    self.repo = nil;
    self.name = nil;
    self.targetName = nil;
    [super dealloc];
}

- (GITObjectHash *)targetObjectHash {
    return [GITObjectHash objectHashWithString:targetName];
}

- (GITRef *)resolve {
    if ( !link ) {
        return self;
    } else {
        return [[[self.repo refResolver] resolveRefWithName:[self.targetName stringByReplacingOccurrencesOfString:@"ref: " withString:@""]] resolve];
    }
}

- (GITObject *)target {
    GITRef *end = [self resolve];
    return [self.repo objectWithSha1:[end targetObjectHash] error:NULL];
}

@end
