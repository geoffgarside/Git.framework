//
//  GITPackFileVersionTwo.h
//  Git.framework
//
//  Created by Geoff Garside on 07/11/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackFile.h"


typedef enum {
    GITPackFileDeltaTypeOfs  = 6,
    GITPackFileDeltaTypeRefs = 7,
} GITPackFileDeltaType;

typedef struct {
    int type;
    off_t offset;
    size_t size;
} GITPackFileObjectHeader;

@class GITPackIndex;
@interface GITPackFileVersionTwo : GITPackFile {
    NSData *data;
    GITPackIndex *index;
}

@property (copy) NSData *data;
@property (retain) GITPackIndex *index;

- (GITPackObject *)unpackObjectAtOffset: (off_t)offset sha1: (GITObjectHash *)objectHash error: (NSError **)error;
- (GITPackObject *)unpackDeltaPackedObjectAtOffset: (off_t)offset objectHeader: (GITPackFileObjectHeader *)header sha1: (GITObjectHash *)objectHash error: (NSError **)error;

- (NSRange)checksumRange;

@end
