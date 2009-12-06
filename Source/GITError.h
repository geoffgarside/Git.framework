//
//  GITError.h
//  Git.framework
//
//  Created by Geoff Garside on 15/09/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//
//  We use the __git_error and __git_error_domain macros to
//  make it easier to enter and update the error codes in
//  the project. If you define them here with the macro then
//  you can copy/paste the same code into GITErrors.m and
//  then add the value argument to the end of them.
//

#import <Foundation/Foundation.h>
#define __git_error(code) extern const NSInteger code
#define __git_error_domain(dom) extern NSString * dom

__git_error_domain(GITErrorDomain);

#import "NSError-OBExtensions.h"
#import "OBError.h"

// Define GITError* macros to use the OmniBase _OBError helper functions. If we decide to move away from OmniBase code, we can just redfine these.
#define GITError(error, code, description) _OBError(error, GITErrorDomain, code, __FILE__, __LINE__, NSLocalizedDescriptionKey, description, nil)
#define GITErrorWithInfo(error, code, ...) _OBError(error, GITErrorDomain, code, __FILE__, __LINE__, ## __VA_ARGS__)

#define NSLocalizedStringWithArguments(format, comment, ...) [NSString stringWithFormat:NSLocalizedString(format, comment), ## __VA_ARGS__]

#pragma mark GITRepo Errors
__git_error(GITRepoErrorRootDoesNotExist);
__git_error(GITRepoErrorRootNotAccessible);
__git_error(GITRepoErrorRootInsane);

#pragma mark GITRefResolver Errors
__git_error(GITRefResolverErrorRefNotFound);

#pragma mark GITPackFile Errors
__git_error(GITPackFileErrorPathNotFound);
__git_error(GITPackFileErrorPathIsDirectory);
__git_error(GITPackFileErrorFileIsInvalid);
__git_error(GITPackFileErrorVersionUnsupported);

#pragma mark GITPackIndex Errors
__git_error(GITPackIndexErrorPathNotFound);
__git_error(GITPackIndexErrorPathIsDirectory);
__git_error(GITPackIndexErrorVersionUnsupported);
__git_error(GITPackIndexErrorCorrupt);

#undef __git_error
#undef __git_error_domain
