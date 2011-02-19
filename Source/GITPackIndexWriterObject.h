//
//  GITPackIndexWriterObject.h
//  Git.framework
//
//  Created by Geoff Garside on 06/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITObjectHash;
@interface GITPackIndexWriterObject : NSObject {
    GITObjectHash *sha1;
    NSUInteger offset;
    uint32_t crc32;
}

@property (retain) GITObjectHash *sha1;
@property (assign) NSUInteger offset;
@property (assign,setter=setCRC32:) uint32_t crc32;

+ (GITPackIndexWriterObject *)indexWriterObjectWithName: (GITObjectHash *)sha1 atOffset: (NSUInteger)offset;

- (id)initWithName: (GITObjectHash *)sha1 atOffset: (NSUInteger)offset;

- (BOOL)isEqual: (id)other;
- (BOOL)isEqualToIndexWriterObject: (GITPackIndexWriterObject *)rhs;
- (BOOL)isEqualToObjectHash: (GITObjectHash *)rhs;

/*!
 * Returns an NSComparisonResult value that indicates whether the receiver is greater than,
 * equal to, or less than a given index writer object.
 *
 * \param hash The index writer object with which to compare the receiver. This value must
 * not be nil. If the value is nil, the behavior is undefined.
 * \return NSOrderedAscending if the value of \a hash is greater than the receiver’s,
 * NSOrderedSame if they’re equal, and NSOrderedDescending if the value of \a hash is less
 * than the receiver’s.
 */
- (NSComparisonResult)compare: (GITPackIndexWriterObject *)obj;

@end
