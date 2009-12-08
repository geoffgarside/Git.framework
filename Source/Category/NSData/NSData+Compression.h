//
//  NSData+Compression.h
//
//  Created by Geoffrey Garside on 29/06/2008.
//  Believed to be Public Domain.
//
//  Methods extracted from source given at
//  http://www.cocoadev.com/index.pl?NSDataCategory
//

#import <Foundation/NSData.h>

/*! Adds compression and decompression messages to NSData.
 * Methods extracted from source given at
 * http://www.cocoadev.com/index.pl?NSDataCategory
 */
@interface NSData (Compression)

#pragma mark -
#pragma mark Zlib Compression routines
/*! Returns a data object containing a Zlib decompressed copy of the receivers contents.
 * \returns A data object containing a Zlib decompressed copy of the receivers contents.
 */
- (NSData *) zlibInflate;
/*! Returns a data object containing a Zlib compressed copy of the receivers contents.
 * \returns A data object containing a Zlib compressed copy of the receivers contents.
 */
- (NSData *) zlibDeflate;

#pragma mark -
#pragma mark Gzip Compression routines
/*! Returns a data object containing a Gzip decompressed copy of the receivers contents.
 * \returns A data object containing a Gzip decompressed copy of the receivers contents.
 */
- (NSData *) gzipInflate;
/*! Returns a data object containing a Gzip compressed copy of the receivers contents.
 * \returns A data object containing a Gzip compressed copy of the receivers contents.
 */
- (NSData *) gzipDeflate;

@end
