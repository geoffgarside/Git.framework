//
//  GITPackFileWriterVersionTwo.h
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackFileWriter.h"
#import <CommonCrypto/CommonDigest.h>


@class GITPackIndexWriter;
@interface GITPackFileWriterVersionTwo : GITPackFileWriter {
    char state;
    CC_SHA1_CTX ctx;
    NSInteger offset;
    NSUInteger objectsWritten;
    NSArray *objects;
    GITPackIndexWriter *indexWriter;
}

@end
