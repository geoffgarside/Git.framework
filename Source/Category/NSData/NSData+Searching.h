//
//  NSData+Searching.h
//
//  Created by Geoffrey Garside on 17/07/2008.
//  Copyright 2008 Geoffrey Garside. All rights reserved.
//

#import <Foundation/NSData.h>

@interface NSData (Searching)

/*! Returns the range of bytes up to the first occurrence of byte c from start.
 * \return Range of bytes up to the first occurrence of c from start. If c
 * can not be found then the NSRange.location will be set to NSNotFound.
 * \see memchr
 */
- (NSRange)rangeFrom:(NSInteger)start toByte:(NSInteger)c;

/*! Returns the range of bytes up to the first NULL byte from start.
 * \return Range of bytes up to the first NULL from start. If no NULL
 * can be found then the NSRange.location will be set to NSNotFound.
 * \see memchr
 */
- (NSRange)rangeOfNullTerminatedBytesFrom:(NSInteger)start;

/*! Returns a data object containing a copy of the receiver's bytes
 * that fall within the limits specified by a given index and the
 * end of the bytes.
 * \param index Start of the range which defines the limits to extract.
 * \return A data object containing a copy of the receiver's bytes
 * that fall within the limits of index and the end of the bytes.
 * \see -subdataWithRange:
 */
- (NSData*)subdataFromIndex:(NSUInteger)index;

/*! Returns a data object containing a copy of the receiver's bytes
 * that fall within the first byte and index.
 * \param index End of the range which defines the limits to extract.
 * \return A data object containing a copy of the receiver's bytes
 * that fall within the first byte and index.
 * \see -subdataWithRange:
 */
- (NSData*)subdataToIndex:(NSUInteger)index;

@end
