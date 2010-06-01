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
//! \name Zlib Compression and Decompression
/*! Returns a data object containing a Zlib decompressed copy of the receivers contents.
 * \returns A data object containing a Zlib decompressed copy of the receivers contents.
 */
- (NSData *) zlibInflate;
/*! Returns a data object containing a Zlib compressed copy of the receivers contents.
 * \returns A data object containing a Zlib compressed copy of the receivers contents.
 */
- (NSData *) zlibDeflate;

/*!
 * Inflates the data into a given buffer starting at a certain offset.
 *
 * \param buffer A pointer to an instance of NSMutableData to popluated with the inflated data.
 * \param offset The offset at which to start reading from [self bytes]
 * \param error NSError describing the error which occurred
 * \return The number of bytes consumed
 * \internal
 * This method is not part of the original cocoadev.com source
 */
- (int) zlibInflateInto: (NSMutableData *)buffer offset:(NSUInteger) offset;

#pragma mark -
#pragma mark Gzip Compression routines
//! \name GZip Compression and Decompression
/*! Returns a data object containing a Gzip decompressed copy of the receivers contents.
 * \returns A data object containing a Gzip decompressed copy of the receivers contents.
 */
- (NSData *) gzipInflate;
/*! Returns a data object containing a Gzip compressed copy of the receivers contents.
 * \returns A data object containing a Gzip compressed copy of the receivers contents.
 */
- (NSData *) gzipDeflate;

@end
