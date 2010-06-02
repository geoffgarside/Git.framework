//
//  GITDateTime.h
//  Git.framework
//
//  Created by Geoff Garside on 10/01/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * Git objects specify their creation and other dates along with the associated
 * time zone.
 *
 * This class tracks these pieces of information and also aids in
 * creation of the date time objects from the UNIX timestamp and time zone offsets
 * used in stored git objects.
 */
@interface GITDateTime : NSObject {
    NSDate *date;               //!< Date
    NSTimeZone *timeZone;       //!< Time Zone
}

//! \name Properties
@property (copy) NSDate *date;
@property (copy) NSTimeZone *timeZone;

//! \name Creating and Initialising DateTimes
/*!
 * Creates and returns a date time object for the \a date in the local time zone.
 *
 * \param date Date object giving the date and time for the receiver
 * \return date time object
 * \sa initWithDate:
 */
+ (GITDateTime *)dateTimeWithDate: (NSDate *)date;

/*!
 * Creates and returns a date time object for the \a date in the given \a timeZone.
 *
 * \param date Date object giving the date and time for the receiver
 * \param timeZone time zone of the date and time
 * \return date time object
 * \sa initWithDate:timeZone:
 */
+ (GITDateTime *)dateTimeWithDate: (NSDate *)date timeZone: (NSTimeZone *)timeZone;

/*!
 * Creates and returns a date time object from the UNIX timestamp \a seconds and the string \a offset.
 *
 * The \a offset is normally of the form "+0100" or "-0100", the \a seconds counted from the start of
 * the UNIX Epoch which is the first of January 1970 rather than the Mac OS X Reference Date which is
 * the first of January 2001.
 *
 * \param seconds UNIX timestamp specifying the date
 * \param offset Zone offset from Greenwich in "+/-HHMM" format
 * \return date time object
 * \sa initWithTimestamp:timeZoneOffset:
 */
+ (GITDateTime *)dateTimeWithTimestamp: (NSTimeInterval)seconds timeZoneOffset: (NSString *)offset;

/*!
 * Creates and returns a date time object for the \a date in the local time zone.
 *
 * \param date Date object giving the date and time for the receiver
 * \return date time object
 * \sa dateTimeWithDate:
 * \sa initWithDate:timeZone:
 */
- (id)initWithDate: (NSDate *)date;

/*!
 * Creates and returns a date time object for the \a date in the given \a timeZone.
 *
 * \param date Date object giving the date and time for the receiver
 * \param timeZone time zone of the date and time
 * \return date time object
 */
- (id)initWithDate: (NSDate *)date timeZone: (NSTimeZone *)timeZone;

/*!
 * Creates and returns a date time object from the UNIX timestamp \a seconds and the string \a offset.
 *
 * The \a offset is normally of the form "+0100" or "-0100", the \a seconds counted from the start of
 * the UNIX Epoch which is the first of January 1970 rather than the Mac OS X Reference Date which is
 * the first of January 2001.
 *
 * \param seconds UNIX timestamp specifying the date
 * \param offset Zone offset from Greenwich in "+/-HHMM" format
 * \return date time object
 * \sa initWithDate:timeZone:
 */
- (id)initWithTimestamp: (NSTimeInterval)seconds timeZoneOffset: (NSString *)offset;

/*!
 * Returns a string representation of the receiver with the given format.
 *
 * \param format The date format for the receiver. See Data Formatting Programming Guide for Cocoa for a
 *               list of the conversion specifiers permitted in date format strings.
 * \return string representation of the receiver
 * \sa http://devworld.apple.com/mac/library/documentation/Cocoa/Conceptual/DataFormatting/DataFormatting.html
 */
- (NSString *)stringWithFormat: (NSString *)format;

@end
