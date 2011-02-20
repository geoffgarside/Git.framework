//
//  GITPackIndexWriterVersionTwo.h
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "GITPackIndexWriter.h"


@interface GITPackIndexWriterVersionTwo : GITPackIndexWriter {
    char state;                 //!< Internal state of the writer
    CC_SHA1_CTX ctx;            //!< CommonCrypto checksum context
    uint32_t fanoutTable[256];  //!< Fanout table
    NSMutableArray *objects;    //!< Indexed objects
    NSInteger objectsWritten;   //!< Count of objects written
    NSMutableData *extOffsets;  //!< Extended offsets data
    NSData *packChecksum;       //!< PACK file checksum
}

/*!
 * Returns the fanout table array
 *
 * \return fanout table array
 */
- (uint32_t *)fanoutTable;

//! \name Output stream writers
/*!
 * Writes and checksums the buffer into the stream.
 *
 * \param stream Output stream to write to
 * \param buffer Bytes to write to the stream
 * \param length Number of bytes to be written to the stream
 * \return number of bytes written
 * \sa stream:writeData:
 */
- (NSInteger)stream: (NSOutputStream *)stream write: (const uint8_t *)buffer maxLength: (NSUInteger)length;

/*!
 * Writes and checksums the data into the stream.
 *
 * \param stream Output stream to write to
 * \param data Data to write to the stream
 * \return number of bytes written
 * \sa stream:write:maxLength:
 */
- (NSInteger)stream: (NSOutputStream *)stream writeData: (NSData *)data;

/*!
 * Writes the checksum of the written data into the stream.
 *
 * \param stream Output stream to write the checksum to
 * \return number of bytes written
 * \sa stream:writeData:
 */
- (NSInteger)writeChecksumToStream: (NSOutputStream *)stream;

/*!
 * Returns the index header data.
 *
 * \return index header data
 */
- (NSData *)indexHeaderData;

//! \name Writer Methods
/*!
 * Writes PACK Index header to the stream.
 *
 * \param stream Output stream to write the object entry to
 * \return number of bytes written
 */
- (NSInteger)writeHeaderToStream: (NSOutputStream *)stream;

/*!
 * Writes the object name to the stream.
 *
 * \param stream Output stream to write the object entry to
 * \return number of bytes written
 */
- (NSInteger)writeObjectNameToStream: (NSOutputStream *)stream;

/*!
 * Writes the CRC32 values to the stream.
 *
 * \param stream Output stream to write the object entry to
 * \return number of bytes written
 */
- (NSInteger)writeCRC32ValueToStream: (NSOutputStream *)stream;

/*!
 * Writes the offset values to the stream.
 *
 * \param stream Output stream to write the object entry to
 * \return number of bytes written
 */
- (NSInteger)writeOffsetValueToStream: (NSOutputStream *)stream;

/*!
 * Writes the extended offsets to the stream.
 *
 * \param stream Output stream to write the object entry to
 * \return number of bytes written
 */
- (NSInteger)writeExtendedOffsetsToStream: (NSOutputStream *)stream;

/*!
 * Writes the PACK file checksum to the stream.
 *
 * \param stream Output stream to write the object entry to
 * \return number of bytes written
 */
- (NSInteger)writePackChecksumToStream: (NSOutputStream *)stream;

@end
