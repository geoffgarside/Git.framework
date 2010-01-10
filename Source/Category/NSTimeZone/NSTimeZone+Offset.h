//
//  NSTimeZone+Offset.h
//
//  Created by Geoffrey Garside on 28/07/2008.
//  Copyright (c) 2008 Geoff Garside
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSTimeZone.h>

@interface NSTimeZone (Offset)

/*! Creates and returns a time zone with the specified offset.
 * The string is broken down into the hour and minute components
 * which are then used to work out the number of seconds from GMT.
 * \param offset The timezone offset as a string such as "+0100"
 * \return A time zone with the specified offset
 * \see +timeZoneForSecondsFromGMT:
 */
+ (id)timeZoneWithStringOffset:(NSString*)offset;

/*! Returns the receivers offset as an HHMM formatted string.
 * \return The receivers offset as a string in HHMM format.
 */
- (NSString*)offsetString;
@end
