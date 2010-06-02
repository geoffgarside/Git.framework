//
//  GITPackIndexVersionTwo.h
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackIndex.h"


@interface GITPackIndexVersionTwo : GITPackIndex {
    NSData *data;
    NSArray *fanoutTable;
}

@property (copy) NSData *data;
@property (copy) NSArray *fanoutTable;

/*!
 * Returns the index of the SHA1 contained in \a packedSha.
 *
 * \author Brian Chapados
 * \param packedSha NSData containing the packed SHA1 of the object to return the index of
 * \return index of the SHA1 in \a packedSha, or \c NSNotFound if not found
 * \sa indexOfSha1:
 */
- (NSUInteger)indexOfPackedSha1: (NSData *)packedSha;

/*!
 * Returns the offset value from the position specified in the extended offset table at the specified \a idx.
 *
 * \param idx Index position of the offset to retrieve
 * \return the offset at the specified index position
 * \sa packOffsetAtIndex:
 * \sa packOffsetForSha1:error:
 * \sa packOffsetForSha1:
 */
- (off_t)extendedPackOffsetAtOffset: (uint32_t)idx;

/*!
 * Returns the offset in the PACK file of the object \a packedSha.
 *
 * \param packedSha SHA1 of the object to get the offset of
 * \param error NSError describing the error which occurred
 * \return offset in the PACK of the object \a packedSha or NSNotFound if an error occurred
 * \sa packOffsetForSha1:error:
 * \sa packOffsetForSha1:
 * \sa packOffsetAtIndex:
 */
- (off_t)packOffsetForPackedSha1: (NSData *)packedSha error: (NSError **)error;

- (NSRange)fanoutTableRange;
- (NSRange)shaTableRange;
- (NSRange)crcTableRange;
- (NSRange)offsetTableRange;
- (NSRange)extendedOffsetTableRange;
- (NSRange)packChecksumRange;
- (NSRange)indexChecksumRange;

@end
