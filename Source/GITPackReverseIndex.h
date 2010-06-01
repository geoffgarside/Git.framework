//
//  GITPackReverseIndex.h
//  Git.framework
//
//  Created by Geoff Garside on 07/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITPackIndex;

/*!
 * This class provides a mapping between offsets and SHA1 objects.
 *
 * In contrast to the PACK Index which maps SHA1 objects to their offsets in a
 * PACK file the Reverse Index allows for fast lookups of
 * \li an objects SHA1 given its offset
 * \li the offset of adjacent objects
 *
 * The latter of these allows the \e packed size of an object to be easily
 * determined by locating the next offset and subtracting the current offset
 * from it. As the PACK object header only records the objects decompressed size
 * this is the only way to quickly obtain the \e packed size.
 *
 * The GITPackReverseIndex was originally developed by Brian Chapados in the
 * CocoaGit project which was the fore-runner to this project.
 */
@interface GITPackReverseIndex : NSObject {
    GITPackIndex *index;
    CFMutableArrayRef offsets;
    NSUInteger size;
}

@property (assign) GITPackIndex *index;

//! \name Creating and Initialising Reverse Indexes
/*!
 * Creates and returns a reverse index object with the \a packIndex.
 *
 * \param packIndex The PACK Index the reverse index is based on
 * \return Reverse index object with the \a packIndex
 * \sa initWithPackIndex:
 */
+ (GITPackReverseIndex *)reverseIndexWithPackIndex: (GITPackIndex *)packIndex;

/*!
 * Returns a reverse index object with the \a packIndex.
 *
 * \param packIndex The PACK Index the reverse index is based on
 * \return Reverse index object with the \a packIndex
 * \sa reverseIndexWithPackIndex:
 */
- (id)initWithPackIndex: (GITPackIndex *)packIndex;

//! \name Finding Indexes for Offsets
/*!
 * Returns the index into the PACK Indexes Main Index Table where the \a offset can be found.
 *
 * The Main Index Table of a PackIndex file differs between versions one and two but both
 * contain rows specifying the position into the related PACK file at which the data for a
 * given object can be read.
 *
 * \param offset offset to find the index of
 * \return row number in the PACK Index Table of the \a offset
 */
- (NSUInteger)indexWithOffset: (off_t)offset;

//! \name Determining related offsets for offsets
/*!
 * Returns the offset in the PACK file of the object sorted immediately after the object stored at \a offset.
 *
 * If the \a offset is not found then \c NSNotFound is returned, if the \a offset
 * is the last offset then \c -1 is returned.
 *
 * \param offset offset of the object to get the next offset of
 * \return offset of the next offset, NSNotFound if not found, -1 if last offset
 */
- (off_t)nextOffsetAfterOffset: (off_t)offset;

/*!
 * Returns the offset in the PACK file which is the start of the object data spanning \a offset.
 *
 * Essentially the method "rounds down" the \a offset to the nearest start of object data.
 *
 * Returns the offset of the last object if the \a offset is greater than the offset
 * of the last object and the offset of the first offset if the \a offset is less than
 * the offset of the first object.
 *
 * \param offset offset
 * \return start of object data range containing \a offset or per discussion
 */
- (off_t)baseOffsetWithOffset: (off_t)offset;

//! \name Internal Methods
/*!
 * Creates the reverse index offsets table.
 *
 * Creates the table describing the mapping from offsets to SHA1 objects based on the contents
 * of the associated GITPackIndex.
 *
 * \return YES if successfully created, NO if an error occured
 * \sa initWithPackIndex:
 */
- (BOOL)compileReverseIndexTable;

@end
