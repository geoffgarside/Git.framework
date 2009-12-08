//
//  GITObject.h
//  Git.framework
//
//  Created by Geoff Garside on 08/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    GITObjectTypeUnknown = 0,
    GITObjectTypeCommit  = 1,
    GITObjectTypeTree    = 2,
    GITObjectTypeBlob    = 3,
    GITObjectTypeTag     = 4,
} GITObjectType;

@interface GITObject : NSObject {

}

@end
