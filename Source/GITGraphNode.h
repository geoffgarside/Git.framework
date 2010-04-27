//
//  GITGraphNode.h
//  Git.framework
//
//  Created by Geoff Garside on 27/04/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GITGraphNode : NSObject {
    id key;
    id object;
}

- (id)initWithObject: (id)object key: (id)key;

- (BOOL)isEqual: (id)other;

@end
