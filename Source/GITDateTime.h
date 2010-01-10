//
//  GITDateTime.h
//  Git.framework
//
//  Created by Geoff Garside on 10/01/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GITDateTime : NSObject {
    NSDate *date;               //!< Date
    NSTimeZone *timeZone;       //!< Time Zone
}

//! \name Properties
@property (copy) NSDate *date;
@property (copy) NSTimeZone *timeZone;

//! \name Creating and Initialising DateTimes
+ (GITDateTime *)dateTimeWithDate: (NSDate *)date;
+ (GITDateTime *)dateTimeWithDate: (NSDate *)date timeZone: (NSTimeZone *)timeZone;
+ (GITDateTime *)dateTimeWithTimestamp: (NSTimeInterval)seconds timeZoneOffset: (NSString *)offset;

- (id)initWithDate: (NSDate *)date;
- (id)initWithDate: (NSDate *)date timeZone: (NSTimeZone *)timeZone;
- (id)initWithTimestamp: (NSTimeInterval)seconds timeZoneOffset: (NSString *)offset;

@end
