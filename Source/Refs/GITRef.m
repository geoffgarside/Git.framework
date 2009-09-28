//
//  GITRef.m
//  Git.framework
//
//  Created by Geoff Garside on 20/09/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITRef.h"


@implementation GITRef

@synthesize name;

+ (id)refWithName: (NSString *)theName {
    return [[[GITRef alloc] initWithName:theName] autorelease];
}

- (id)initWithName:(NSString *)theName {
    if ( ![super init] )
        return nil;

    self.name = theName;

    return self;
}

- (void)dealloc {
    self.name = nil;
    [super dealloc];
}

@end
