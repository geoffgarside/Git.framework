//
//  GITPackFileVersionTwo.m
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackFileVersionTwo.h"
#import "GITPackIndex.h"

@implementation GITPackFileVersionTwo

@synthesize data, index;

- (NSUInteger)version {
    return 2;
}

- (id)initWithData: (NSData *)packData indexPath:(NSString *)indexPath error:(NSError **)error {
    if ( ![super init] )
        return nil;

    self.data = packData;
    self.index = [GITPackIndex packIndexWithPath:indexPath error:error];

    return self;
}

- (void)dealloc {
    self.data = nil;
    self.index = nil;

    [super dealloc];
}

@end
