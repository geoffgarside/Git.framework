//
//  GITPackFileWriterVersionTwo.h
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackFileWriter.h"
#import <CommonCrypto/CommonDigest.h>


@interface GITPackFileWriterVersionTwo : GITPackFileWriter {
    CC_SHA1_CTX ctx;
}

@end
