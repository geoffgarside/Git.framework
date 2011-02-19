//
//  GITPackFileWriter.h
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITPackIndexWriter, GITRevList, GITCommit;

/*!
 * A class cluster
 */
@interface GITPackFileWriter : NSObject <NSStreamDelegate> { }

//! \name Creating and Initialising GITPackFileWriter objects
/*!
 * Creates an autoreleased PACK file writer for the default PACK file version.
 *
 * \return PACK file writer for the default version
 */
+ (GITPackFileWriter *)packWriter;

/*!
 * Creates an autoreleased PACK file writer for the specified \a version.
 *
 * \param version Version of writer to create
 * \return PACK file writer with the specified \a version, nil if \a version is unsupported.
 */
+ (GITPackFileWriter *)packWriterVersion: (NSUInteger)version;

/*!
 * Initialises a PACK file writer for the default PACK file version.
 *
 * \return PACK file writer for the default version
 */
- (id)initWithDefaultVersion;

/*!
 * Initialises a PACK file writer for the specified \a version.
 *
 * \param version Version of the writer to create
 * \param[out] error NSError describing the error that occurred
 * \return PACK file writer for the specified \a version, or nil on error
 */
- (id)initWithVersion: (NSUInteger)version error: (NSError **)error;

//! \name Adding to the PACK file
/*!
 * Add the objects reachable from the provided \a revList to the reciever.
 *
 * \param revList Rev list of objects to add to the receiver.
 */
- (void)addObjectsFromRevList: (GITRevList *)revList;

/*!
 * Add the objects reachable from the provided \a commit to the receiver.
 *
 * \param commit Commit object to reach objects from.
 * \sa addObjectsFromRevList:
 */
- (void)addObjectsFromCommit: (GITCommit *)commit;

//! \name PACK file naming
/*!
 * Returns the name of the receiver derived from the objects to be packed.
 *
 * \return SHA1 string name of the receiver derived from the objects to the packed
 */
- (NSString *)name;

/*!
 * Returns the file name of the receiver.
 *
 * \return File name of the receiver.
 * \sa name
 */
- (NSString *)fileName;

//! \name Writing the PACK File
/*!
 * Writes the PACK file contents to the provided \a stream in the NSRunLoop specified.
 *
 * \todo We need a way of getting any stream errors sent back to the client
 * \param stream Output stream to write the PACK index data to
 * \param runLoop NSRunLoop to schedule the writing in
 */
- (void)writeToStream: (NSOutputStream *)stream inRunLoop: (NSRunLoop *)runLoop;

/*!
 * Writes the PACK file contents to the provided \a steam.
 *
 * This method using Polling rather than run-loop scheduling to perform the writing.
 *
 * \param stream Output stream to write the PACK index data to
 * \param[out] error NSError describing any error which occurred
 * \return 0 if writing was successful, -1 if an error occurred.
 */
- (NSInteger)writeToStream: (NSOutputStream *)stream error: (NSError **)error;

//! \name PACK Index Writer
/*!
 * Returns the PACK index writer of the receiver.
 *
 * \return PACK index writer of the receiver
 */
- (GITPackIndexWriter *)indexWriter;

/*!
 * Sets the provided \a indexWriter on the receiver.
 *
 * \param indexWriter PACK index writer for the receiver to populate when it writes itself.
 */
- (void)setIndexWriter: (GITPackIndexWriter *)indexWriter;

@end
