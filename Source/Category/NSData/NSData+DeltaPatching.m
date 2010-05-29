//
//  NSData+DeltaPatching.m
//  Git.framework
//
//  Created by Geoff Garside on 08/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+DeltaPatching.h"


@implementation NSData (DeltaPatching)

- (size_t)deltaPatchingPatchHeaderSize: (const uint8_t **)bytes_p {
    const uint8_t *bytes = *bytes_p;
    size_t size = 0;
    int shift = 0;

    do {
        size |= ((*bytes & 0x7f) << shift);
        *bytes_p += 1;
        shift += 7;
    } while ( (*bytes++ & 0x80) != 0 );

    return size;
}

- (NSData *)dataByDeltaPatchingWithData: (NSData *)delta {
    const uint8_t *deltaBytes   = [delta bytes];
    const uint8_t *endOfDelta   = deltaBytes + [delta length];

    size_t sourceSize = [self deltaPatchingPatchHeaderSize:&deltaBytes];   //!< Get source size
    if ( sourceSize != [self length] )
        [NSException raise:@"NSDataDeltaPatchingException" format:@"Delta Patch data is invalid"];

    size_t targetSize = [self deltaPatchingPatchHeaderSize:&deltaBytes];   //!< Get target size
    NSMutableData *target = [NSMutableData dataWithCapacity:targetSize];

    uint8_t c;
    size_t cp_off, cp_size;

    while ( deltaBytes < endOfDelta ) {
        c = *(deltaBytes++);

        if ( (c & 0x80) != 0 ) {

            cp_off = 0;            /* Calculate the offset */
            if ( 0 != (c & 0x01) ) cp_off  = *(deltaBytes++);
            if ( 0 != (c & 0x02) ) cp_off |= *(deltaBytes++) << 8;
            if ( 0 != (c & 0x04) ) cp_off |= *(deltaBytes++) << 16;
            if ( 0 != (c & 0x08) ) cp_off |= *(deltaBytes++) << 24;

            cp_size = 0;           /* Calculate the size */
            if ( 0 != (c & 0x10) ) cp_size  = *(deltaBytes++);
            if ( 0 != (c & 0x20) ) cp_size |= *(deltaBytes++) << 8;
            if ( 0 != (c & 0x40) ) cp_size |= *(deltaBytes++) << 16;
            if ( cp_size == 0 )    cp_size = 0x10000;

            [target appendData:[self subdataWithRange:NSMakeRange(cp_off, cp_size)]];
        } else if ( c != 0 ) {
            [target appendBytes:deltaBytes length:c];
            deltaBytes += c;
        } else {
            [NSException raise:@"NSDataDeltaPatchingException" format:@"Delta Patch data is invalid"];
            return nil;     //!< Exception should mean this isn't reached, I think
        }
    }

    return [[target copy] autorelease];
}

@end
