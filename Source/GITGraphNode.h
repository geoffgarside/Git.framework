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

@property (readonly,copy) id key;
@property (readonly,assign) id object;

+ (GITGraphNode *)nodeWithObject: (id)object key: (id)key;

- (id)initWithObject: (id)object key: (id)key;

- (BOOL)isEqual: (id)other;

@end
