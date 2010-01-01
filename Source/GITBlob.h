//
//  GITBlob.h
//  Git.framework
//
//  Created by Geoff Garside on 13/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GITObject.h"


/*!
 * This class represents \e Blob objects in a git repository.
 */
@interface GITBlob : GITObject <GITObject> {
    NSData *content;
}

@property (retain) NSData *content;

+ (GITBlob *)blobFromData: (NSData *)data repo: (GITRepo *)repo error: (NSError **)error;

@end
