//
//  GITDateTime.m
//  Git.framework
//
//  Created by Geoff Garside on 10/01/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import "GITDateTime.h"
#import "NSTimeZone+Offset.h"


@implementation GITDateTime

@synthesize date, timeZone;

+ (GITDateTime *)dateTimeWithDate: (NSDate *)date {
    return [[[self alloc] initWithDate:date] autorelease];
}

+ (GITDateTime *)dateTimeWithDate: (NSDate *)date timeZone: (NSTimeZone *)timeZone {
    return [[[self alloc] initWithDate:date timeZone:timeZone] autorelease];
}

+ (GITDateTime *)dateTimeWithTimestamp: (NSTimeInterval)seconds timeZoneOffset: (NSString *)offset {
    return [[[self alloc] initWithTimestamp:seconds timeZoneOffset:offset] autorelease];
}

- (id)initWithDate: (NSDate *)theDate {
    return [self initWithDate:theDate timeZone:[NSTimeZone defaultTimeZone]];
}

- (id)initWithDate: (NSDate *)theDate timeZone: (NSTimeZone *)theTimeZone {
    if ( ![super init] )
        return nil;

    self.date = theDate;
    self.timeZone = theTimeZone;

    return self;
}

- (id)initWithTimestamp: (NSTimeInterval)seconds timeZoneOffset: (NSString *)offset {
    return [self initWithDate:[NSDate dateWithTimeIntervalSince1970:seconds]
                     timeZone:[NSTimeZone timeZoneWithStringOffset:offset]];
}

- (void)dealloc {
    self.date = nil;
    self.timeZone = nil;
    [super dealloc];
}

- (NSString *)stringWithFormat: (NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:format];

    NSString *str = [dateFormatter stringFromDate:date];
    [dateFormatter release];

    return str;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%.0f %@",
            [self.date timeIntervalSince1970], [self.timeZone offsetString]];
}

@end
