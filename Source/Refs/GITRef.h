//
//  GITRef.h
//  Git.framework
//
//  Created by Geoff Garside on 20/09/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GITRef : NSObject {
    NSString *name;
}

@property (copy) NSString *name;

+ (id)refWithName: (NSString *)theName;

- (id)initWithName: (NSString *)theName;

@end
