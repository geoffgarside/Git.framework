//
//  GITPackFileWriterVersionTwo.h
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "GITPackFileWriter.h"
#import "GITObject.h"


@class GITPackIndexWriter;
@interface GITPackFileWriterVersionTwo : GITPackFileWriter {
    char state;                         //!< Internal state of the writer
    CC_SHA1_CTX ctx;                    //!< CommonCrypto checksum context
    NSInteger offset;                   //!< Writing offset
    NSUInteger objectsWritten;          //!< Count of objects written
    NSArray *objects;                   //!< Objects to PACK
    GITPackIndexWriter *indexWriter;    //!< Index writer
}

@property (retain) GITPackIndexWriter *indexWriter;

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

//! \name Helper Methods
/*!
 * Returns the data for the PACK file header.
 *
 * \param numberOfObjects Number of objects to include in the header
 * \return PACK header data
 */
- (NSData *)packedHeaderDataWithNumberOfObjects: (NSUInteger)numberOfObjects;

/*!
 * Returns the data for the PACK object
 *
 * \param type Type of the object to be packed
 * \param data Data of the object to the packed
 * \return PACK object data
 */
- (NSData *)packedObjectDataWithType: (GITObjectType)type andData: (NSData *)data;

//! \name Writer Methods
/*!
 * Returns the next object from the objects array
 *
 * \return next GITObject
 * \sa writeNextObjectToStream:
 */
- (GITObject<GITObject> *)nextObject;

/*!
 * Writes the header data to the stream.
 *
 * \param stream Output stream to write the header to
 * \return number of bytes written to the stream
 * \sa packedHeaderDataWithNumberOfObjects:
 * \sa stream:writeData:
 */
- (NSInteger)writeHeaderToStream: (NSOutputStream *)stream;

/*!
 * Writes the PACK object to the stream
 *
 * \param stream Output stream to write the object to
 * \return number of bytes written to the stream
 * \sa nextObject:
 * \sa stream:writeData:
 */
- (NSInteger)writeNextObjectToStream: (NSOutputStream *)stream;

@end
