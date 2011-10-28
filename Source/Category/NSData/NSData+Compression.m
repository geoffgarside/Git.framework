//
//  NSData+Compression.m
//
//  Created by Geoffrey Garside on 29/06/2008.
//  Believed to be Public Domain.
//
//  Methods extracted from source given at
//  http://www.cocoadev.com/index.pl?NSDataCategory
//

#import "NSData+Compression.h"
#include <zlib.h>

@implementation NSData (Compression)

#pragma mark -
#pragma mark Zlib Compression routines
- (NSData *) zlibInflate
{
    if ([self length] == 0) return self;

    unsigned full_length = [self length];
    unsigned half_length = [self length] / 2;

    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;

    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = [self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;

    if (inflateInit (&strm) != Z_OK) return nil;

    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;

        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd (&strm) != Z_OK) return nil;

    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}
- (NSData *) zlibDeflate
{
    if ([self length] == 0) return self;

    z_stream strm;

    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[self bytes];
    strm.avail_in = [self length];

    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION

    if (deflateInit(&strm, Z_DEFAULT_COMPRESSION) != Z_OK) return nil;

    // 16K chuncks for expansion
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];

    do {

        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];

        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = [compressed length] - strm.total_out;

        deflate(&strm, Z_FINISH);

    } while (strm.avail_out == 0);

    deflateEnd(&strm);

    [compressed setLength: strm.total_out];
    return [NSData dataWithData: compressed];
}

- (int) zlibInflateInto: (NSMutableData *)buffer offset:(NSUInteger) offset {
    int destBufferSize = [buffer length];
    void * destBuffer = [buffer mutableBytes];

    int status;
    BOOL done = NO;

    // First setup the zlib stream object
    z_stream strm;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.next_in = (Bytef *) [self bytes] + offset;
    strm.avail_in = [self length] - offset;
    strm.total_out = 0;

    if ( inflateInit(&strm) != Z_OK) {
        goto finish;
    }

    while ( !done ) {
        if (strm.total_out > destBufferSize) {
            goto finish;
        }

        strm.next_out = destBuffer + strm.total_out;
        strm.avail_out = destBufferSize - strm.total_out;

        status = inflate(&strm, Z_NO_FLUSH);

        if ( status == Z_STREAM_END ) {
            done = YES;
        } else if ( status != Z_OK ) {
            break;
        }
    }

finish:

    inflateEnd(&strm);

    return done ? strm.total_out : -1;
}

#pragma mark -
#pragma mark Gzip Compression routines
- (NSData *) gzipInflate
{
    if ([self length] == 0) return self;

    unsigned full_length = [self length];
    unsigned half_length = [self length] / 2;

    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;

    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = [self length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;

    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = [decompressed length] - strm.total_out;

        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd (&strm) != Z_OK) return nil;

    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}
- (NSData *) gzipDeflate
{
    if ([self length] == 0) return self;

    z_stream strm;

    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[self bytes];
    strm.avail_in = [self length];

    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION

    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED,
        (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;

    // 16K chunks for expansion
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];

    do {

        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];

        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = [compressed length] - strm.total_out;

        deflate(&strm, Z_FINISH);

    } while (strm.avail_out == 0);

    deflateEnd(&strm);

    [compressed setLength: strm.total_out];
    return [NSData dataWithData:compressed];
}

@end
