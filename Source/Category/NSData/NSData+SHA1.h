//
//  NSData+SHA1.h
//
//  Created by Geoffrey Garside on 29/06/2008.
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
//  Based on, believed to be public domain, source code available at
//  http://www.cocoadev.com/index.pl?NSDataCategory, though modified
//  to use the CommonCrypto API available on Mac OS and iPhone platforms.
//

#import <Foundation/NSData.h>

@interface NSData (SHA1)

#pragma mark -
#pragma mark SHA1 Hashing routines
/*! Returns the SHA1 digest of the receivers contents.
 * \return SHA1 digest of the receivers contents.
 */
- (NSData*) sha1Digest;

/*! Returns a string with the SHA1 digest of the receivers contents.
 * \return String with the SHA1 digest of the receivers contents.
 */
- (NSString*) sha1DigestString;

@end
