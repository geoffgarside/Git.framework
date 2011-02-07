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

@end
