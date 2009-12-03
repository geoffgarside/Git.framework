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
}

@property (copy) NSData *data;

/*!
 * Returns the index of the SHA1 contained in \a packedSha.
 *
 * \author Brian Chapados
 * \param packedSha NSData containing the packed SHA1 of the object to return the index of
 * \return index of the SHA1 in \a packedSha, or \c NSNotFound if not found
 * \sa indexOfSha1:
 */
- (NSUInteger)indexOfPackedSha1: (NSData *)packedSha;

@end
