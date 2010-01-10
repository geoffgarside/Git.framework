//
//  NSTimeZone+Offset.m
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

#import "NSTimeZone+Offset.h"

static const unsigned short int HourInSeconds = 3600;
static const unsigned short int MinuteInSeconds = 60;

@implementation NSTimeZone (Offset)

+ (id)timeZoneWithStringOffset:(NSString*)offset
{
    NSString * hours = [offset substringWithRange:NSMakeRange(1, 2)];
    NSString * mins  = [offset substringWithRange:NSMakeRange(3, 2)];
    
    NSTimeInterval seconds = ([hours integerValue] * HourInSeconds) + ([mins integerValue] * MinuteInSeconds);
    if ([offset characterAtIndex:0] == '-')
        seconds = seconds * -1;
    
    return [self timeZoneForSecondsFromGMT:seconds];
}
- (NSString*)offsetString
{
    BOOL negative = NO;
    unsigned short int hours, mins; //!< Shouldn't ever be > 60
    
    NSTimeInterval seconds = [self secondsFromGMT];
    if (seconds < 0) {
        negative = YES;
        seconds = seconds * -1;
    }
    
    hours = (NSInteger)seconds / HourInSeconds;
    mins  = ((NSInteger)seconds % HourInSeconds) / MinuteInSeconds;
    
    return [NSString stringWithFormat:@"%c%02d%02d",
            negative ? '-' : '+', hours, mins];
}

@end
