//
//  GITActor.m
//  Git.framework
//
//  Created by Geoff Garside on 10/01/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITActor.h"


@implementation GITActor

@synthesize name, email;

+ (NSString *)defaultName {
    return @"User";
}

+ (NSString *)defaultEmail {
    NSProcessInfo *pi = [NSProcessInfo processInfo];
    NSDictionary *env = [pi environment];
    return [NSString stringWithFormat:@"%@@%@", [env objectForKey:@"USER"], [pi hostName]];
}

+ (GITActor *)actor {
    return [[[self alloc] initWithName:[self defaultName] email:[self defaultEmail]] autorelease];
}

+ (GITActor *)actorWithName: (NSString *)name {
    return [[[self alloc] initWithName:name] autorelease];
}

+ (GITActor *)actorWithName: (NSString *)name email: (NSString *)email {
    return [[[self alloc] initWithName:name email:email] autorelease];
}

- (id)initWithName: (NSString *)theName {
    NSString *theEmail = [[self class] defaultEmail];
    return [self initWithName:theName email:theEmail];
}

- (id)initWithName: (NSString *)theName email: (NSString *)theEmail {
    if ( ![super init] )
        return nil;

    self.name  = theName;
    self.email = theEmail;

    return self;
}

- (void)dealloc {
    self.name = nil;
    self.email = nil;
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ <%@>", self.name, self.email];
}

@end
