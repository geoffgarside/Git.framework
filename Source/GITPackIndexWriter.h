//
//  GITPackIndexWriter.h
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITObjectHash;

/*!
 * GITPackIndexWriter is a class cluster which provides the ability to
 * create both version one and version two PACK IDX files from data
 * provided by GITPackFileWriter.
 */
@interface GITPackIndexWriter : NSObject <NSStreamDelegate> { }

//! \name Creating and Initialising GITPackIndexWriter objects
/*!
 * Creates an autoreleased PACK index writer for the default index version.
 *
 * \return PACK index writer for the default version
 */
+ (GITPackIndexWriter *)indexWriter;

/*!
 * Creates an autoreleased PACK index writer for the specified \a version.
 *
 * \param version Version of writer to create
 * \return PACK index writer with the specified \a version, nil if \a version is unsupported.
 */
+ (GITPackIndexWriter *)indexWriterVersion: (NSUInteger)version;

/*!
 * Initialises a PACK index writer for the default version.
 *
 * \return PACK index writer for the default version
 */
- (id)initWithDefaultVersion;

/*!
 * Initialises a PACK index writer for the specified \a version.
 *
 * \param version Version of the writer to create
 * \param[out] error NSError describing the error that occurred
 * \return PACK index writer for the specified \a version, or nil on error
 */
- (id)initWithVersion: (NSUInteger)version error: (NSError **)error;

//! \name Adding to the index
/*!
 * Adds an object to the receiver.
 *
 * \param sha1 Object hash name of the object being added to the receiver
 * \param data Data contents of the object being added to the receiver
 * \param offset Offset into the corresponding PACK file where the object is located
 */
- (void)addObjectWithName: (GITObjectHash *)sha1 andData: (NSData *)data atOffset: (NSUInteger)offset;

/*!
 * Adds the PACK checksum data to the receiver.
 *
 * \param packChecksumData NSData object of the corresponding PACK checksum
 */
- (void)addPackChecksum: (NSData *)packChecksumData;

//! \name Writing the PACK Index
/*!
 * Writes the PACK index contents to the provided \a stream in the NSRunLoop specified.
 *
 * \todo We need a way of getting any stream errors sent back to the client
 * \param stream Output stream to write the PACK index data to
 * \param runLoop NSRunLoop to schedule the writing in
 */
- (void)writeToStream: (NSOutputStream *)stream inRunLoop: (NSRunLoop *)runLoop;

/*!
 * Writes the PACK index contents to the provided \a steam.
 *
 * This method using Polling rather than run-loop scheduling to perform the writing.
 *
 * \param stream Output stream to write the PACK index data to
 * \param[out] error NSError describing any error which occurred
 * \return 0 if writing was successful, -1 if an error occurred.
 */
- (NSInteger)writeToStream: (NSOutputStream *)stream error: (NSError **)error;

@end
