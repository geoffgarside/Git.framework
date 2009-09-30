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

#undef __git_error
#undef __git_error_domain
