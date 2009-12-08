//
//  GITError.m
//  Git.framework
//
//  Created by Geoff Garside on 15/09/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITError.h"

#define __git_error(code, val) const NSInteger code = val
#define __git_error_domain(dom, str) NSString * dom = str

__git_error_domain(GITErrorDomain, @"uk.co.geoffgarside.framework.Git");

#pragma mark GITRepo Errors
__git_error(GITRepoErrorRootDoesNotExist, -1);
__git_error(GITRepoErrorRootNotAccessible, -2);
__git_error(GITRepoErrorRootInsane, -3);

#pragma mark GITRefResolver Errors
__git_error(GITRefResolverErrorRefNotFound, -4);

#pragma mark GITPackFile Errors
__git_error(GITPackFileErrorPathNotFound, -5);
__git_error(GITPackFileErrorPathIsDirectory, -6);
__git_error(GITPackFileErrorFileIsInvalid, -7);
__git_error(GITPackFileErrorVersionUnsupported, -8);
__git_error(GITPackFileErrorIndexMissing, -9);
__git_error(GITPackFileErrorObjectTypeUnknown, -10);
__git_error(GITPackFileErrorObjectSizeMismatch, -11);

#pragma mark GITPackIndex Errors
__git_error(GITPackIndexErrorPathNotFound, -12);
__git_error(GITPackIndexErrorPathIsDirectory, -13);
__git_error(GITPackIndexErrorVersionUnsupported, -14);
__git_error(GITPackIndexErrorCorrupt, -15);

#pragma mark GITPackFile & GITPackIndex Errors
__git_error(GITPackErrorObjectNotFound, -16);

#undef __git_error
#undef __git_error_domain
