//
//  GITPackIndexVersionOne.h
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackIndex.h"


@interface GITPackIndexVersionOne : GITPackIndex {
    NSData *data;
    NSArray *fanoutTable;
}

@property (copy) NSData *data;
@property (copy) NSArray *fanoutTable;

/*!
 * Parses the fanout table.
 *
 * This method iterates over the 256 entries in the fan out table and gathers the
 * number of packed SHA1 hashes which start with a byte that is less than or equal
 * to the fanout index value.
 *
 * If the offset fanout table is corrupted a GITPackIndexErrorCorrupt NSError will
 * be returned.
 *
 * \todo Examine memory implications of this method
 * \param error NSError describing the error which occurred
 * \return YES or NO indicating if the offsets were successfully parsed
 * \sa offsets
 * \sa offsets:
 */
- (BOOL)parseFanoutTable: (NSError **)error;

@end
