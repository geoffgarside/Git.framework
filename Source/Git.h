//
//  Git.h
//  Git.framework
//
//  Created by Geoff Garside on 21/04/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark Core
#import "GITRepo.h"
#import "GITError.h"
#import "GITObjectHash.h"

#pragma mark Objects
#import "GITObject.h"
#import "GITCommit.h"
#import "GITBlob.h"
#import "GITTag.h"
#import "GITTree.h"
#import "GITTreeItem.h"

#pragma mark Object Assistance
#import "GITActor.h"
#import "GITDateTime.h"

#pragma mark Refs and Branches
#import "GITBranch.h"
#import "GITRef.h"
#import "GITRefResolver.h"
#import "GITPackedRefsEnumerator.h"

#pragma mark Enumerators
#import "GITCommitEnumerator.h"

#pragma mark PACK Files and Indexes
#import "GITPackFile.h"
#import "GITPackIndex.h"
#import "GITPackObject.h"

#pragma mark Omni Error Extensions
#import "NSError-OBExtensions.h"
#import "OBError.h"
