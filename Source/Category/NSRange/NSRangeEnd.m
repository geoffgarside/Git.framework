//
//  NSRangeEnd.m
//  Git.framework
//
//  Created by Geoff Garside on 06/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "NSRangeEnd.h"


NSUInteger NSRangeEnd(NSRange range) {
    return (range.location + range.length);
}
