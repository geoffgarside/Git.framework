//
//  GITPackIndexWriter+Shared.m
//  Git.framework
//
//  Created by Geoff Garside on 06/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackIndexWriter+Shared.h"
#import "GITObjectHash.h"


@implementation GITPackIndexWriter (Shared)

#pragma mark Silencers
- (uint32_t *)fanoutTable {
    [self doesNotRecognizeSelector: _cmd];
    return NULL;
}
- (NSInteger)stream: (NSOutputStream *)stream write: (uint8_t *)bytes maxLength: (NSUInteger)length {
    [self doesNotRecognizeSelector: _cmd];
    return -1;
}

#pragma mark Fanout Table Methods
- (void)addObjectHashToFanoutTable: (GITObjectHash *)sha1 {
    uint8_t byte = [sha1 firstPackedByte];
    [self fanoutTable][byte] += 1;
}

- (NSInteger)writeFanoutTableToStream: (NSOutputStream *)stream {
    int i;
    uint32_t current = 0, out;

    for ( i = 0; i < 256; i++ ) {
        current += [self fanoutTable][i];
        out = CFSwapInt32HostToBig(current);
        if ( [self stream:stream write:(uint8_t *)&out maxLength:4] < 0 ) {
            return -1;
        }
    }

    return 0;
}

@end
