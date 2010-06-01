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

extern NSString *GITErrorDomain;

#import "NSError-OBExtensions.h"
#import "OBError.h"

// Define GITError* macros to use the OmniBase _OBError helper functions. If we decide to move away from OmniBase code, we can just redfine these.
#define GITError(error, code, description) _OBError(error, GITErrorDomain, code, __FILE__, __LINE__, NSLocalizedDescriptionKey, description, nil)
#define GITErrorWithInfo(error, code, ...) _OBError(error, GITErrorDomain, code, __FILE__, __LINE__, ## __VA_ARGS__)

#define NSLocalizedStringWithArguments(format, comment, ...) [NSString stringWithFormat:NSLocalizedString(format, comment), ## __VA_ARGS__]

enum {
#pragma mark GITRepo Errors
    GITRepoErrorRootDoesNotExist,
    GITRepoErrorRootNotAccessible,
    GITRepoErrorRootInsane,

#pragma mark GITRefResolver Errors
    GITRefResolverErrorRefNotFound,

#pragma mark GITPackFile Errors
    GITPackFileErrorPathNotFound,
    GITPackFileErrorPathIsDirectory,
    GITPackFileErrorFileIsInvalid,
    GITPackFileErrorVersionUnsupported,
    GITPackFileErrorIndexMissing,
    GITPackFileErrorObjectTypeUnknown,
    GITPackFileErrorObjectSizeMismatch,
    GITPackFileErrorInflationFailed,

#pragma mark GITPackIndex Errors
    GITPackIndexErrorPathNotFound,
    GITPackIndexErrorPathIsDirectory,
    GITPackIndexErrorVersionUnsupported,
    GITPackIndexErrorCorrupt,

#pragma mark GITPackFile & GITPackIndex Errors
    GITPackErrorObjectNotFound,

#pragma mark GITPackCollection Errors
    GITPackCollectionErrorDirectoryDoesNotExist,

#pragma mark GITLooseObject Errors
    GITLooseObjectErrorDirectoryDoesNotExist,
    GITLooseObjectErrorObjectNotFound,

#pragma mark GITObject Parsing Errors
    GITObjectErrorParsingFailed,
};
