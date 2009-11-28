//
//  GITPackedRefsEnumerator.h
//  Git.framework
//
//  Created by Geoff Garside on 04/10/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/NSEnumerator.h>

@class NSData, NSString, GITRepo;

/*!
 * The \c GITPackedRefsEnumerator class provides enumeration
 * of \c packed-refs contents.
 *
 * This enumerator allows for iteration over the contents of
 * \c packed-refs using either normal enumeration
 *
\verbatim
id ref;
GITRepo *repo = [GITRepo repo];
GITPackedRefsEnumerator *e = [GITPackedRefsEnumerator enumeratorForRepo:repo];

while ( (object = [e nextObject]) ) {
    // do something with object...
}
\endverbatim
 *
 * or using Fast Enumeration
 *
\verbatim
GITRepo *repo = [GITRepo repo];

for ( id object in [GITPackedRefsEnumerator enumeratorForRepo:repo]) {
    // do something with object...
}
\endverbatim
 */
@interface GITPackedRefsEnumerator : NSEnumerator {
    NSString *packedRefsPath;
    BOOL hasPackedRefs;
    BOOL started;

    NSData *packedRefs;
    NSRange currentRange;
}

//! \name Creating and Initialising Packed Refs Enumerator
/*!
 * Returns a packed refs enumerator for the provided repository￼.
 *
 * \param theRepo Repository to create the enumerator for
 * \return packed refs enumerator
 * \sa initWithRepo:
 */
+ (GITPackedRefsEnumerator *)enumeratorForRepo: (GITRepo *)theRepo;

/*!
 * Returns a packed refs enumerator for the provided repository￼.
 *
 * \param theRepo Repository to create the enumerator for
 * \return packed refs enumerator
 */
- (id)initWithRepo: (GITRepo *)theRepo;

@end
