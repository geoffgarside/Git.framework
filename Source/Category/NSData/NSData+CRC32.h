//
//  NSData+CRC32.h
//
//  Created by Geoffrey Garside on 08/11/2010.
//  Believed to be Public Domain.
//
//  Methods extracted from source given at
//  http://www.cocoadev.com/index.pl?NSDataCategory
//

#import <Foundation/NSData.h>

/*! Adds 32-bit cyclic redundancy check message to NSData.
 * Methods extracted from source given at
 * http://www.cocoadev.com/index.pl?NSDataCategory
 */
@interface NSData (CRC32)

/*!
 * Calculates the CRC32 value of the receiver
 *
 * \return 32-bit CRC of the receiver.
 */
- (uint32_t)crc32;

@end
