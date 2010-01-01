//
//  NSData+DeltaPatching.h
//  Git.framework
//
//  Created by Geoff Garside on 08/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/NSData.h>


/*!
 * This category provides delta patching support to enable the restoration of
 * delta compressed data.
 */
@interface NSData (DeltaPatching)

//! \name Patching
/*!
 * Returns the restored data from patching the \a deltaData with the receiver.
 *
 * \param deltaData NSData to patch the receiver with
 * \return restored data
 */
- (NSData *)dataByDeltaPatchingWithData: (NSData *)deltaData;

@end
