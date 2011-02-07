//
//  GITPackIndexWriter+Shared.h
//  Git.framework
//
//  Created by Geoff Garside on 06/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackIndexWriter.h"


@class GITObjectHash;
@interface GITPackIndexWriter (Shared)

- (void)addObjectHashToFanoutTable: (GITObjectHash *)sha1;
- (NSInteger)writeFanoutTableToStream: (NSOutputStream *)stream;
- (NSArray *)sortedArrayOfObjects: (NSArray *)objects;

@end
