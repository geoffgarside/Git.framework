//
//  NSData+SHA1.m
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

#import "NSData+SHA1.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSData (SHA1)

#pragma mark -
#pragma mark SHA1 Hashing macros
#define HEComputeDigest(method)                                         \
    CC_##method##_CTX ctx;                                              \
    unsigned char digest[CC_##method##_DIGEST_LENGTH];                  \
    CC_##method##_Init(&ctx);                                           \
    CC_##method##_Update(&ctx, [self bytes], [self length]);            \
    CC_##method##_Final(digest, &ctx);

#define HEComputeDigestNSData(method)                                   \
    HEComputeDigest(method)                                             \
    return [NSData dataWithBytes:digest length:CC_##method##_DIGEST_LENGTH];

#define HEComputeDigestNSString(method)                                 \
    static char __HEHexDigits[] = "0123456789abcdef";                   \
    unsigned char digestString[2*CC_##method##_DIGEST_LENGTH + 1];      \
    unsigned int i;                                                     \
    HEComputeDigest(method)                                             \
    for(i=0; i<CC_##method##_DIGEST_LENGTH; i++) {                      \
        digestString[2*i]   = __HEHexDigits[digest[i] >> 4];            \
        digestString[2*i+1] = __HEHexDigits[digest[i] & 0x0f];          \
    }                                                                   \
    digestString[2*CC_##method##_DIGEST_LENGTH] = '\0';                 \
    return [NSString stringWithCString:(char *)digestString encoding:NSASCIIStringEncoding];

#pragma mark -
#pragma mark SHA1 Hashing routines
- (NSData*) sha1Digest
{
	HEComputeDigestNSData(SHA1);
}
- (NSString*) sha1DigestString
{
	HEComputeDigestNSString(SHA1);
}

@end
