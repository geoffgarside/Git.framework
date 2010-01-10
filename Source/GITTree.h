//
//  GITTree.h
//  Git.framework
//
//  Created by Geoff Garside on 13/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GITObject.h"


@class GITRepo;

/*!
 * This class represents \e Tree objects in a git repository.
 *
 * Tree objects store a list of directory items with their associated
 * modes and SHA1 references. The SHA1 references are in the packed form.
 * \verbatim
 * 100644 .gitignore a5cc2925ca8258af241be7e5b0381edf30266302
 * 100644 README 69e27356ef629022720d868ab0c0e3394775b6c1
 * \endverbatim
 */
@interface GITTree : GITObject <GITObject> {
    NSArray *items;
}

@property (copy) NSArray *items;

+ (GITTree *)treeFromData: (NSData *)data repo: (GITRepo *)repo error: (NSError **)error;

- (id)initFromData: (NSData *)data repo: (GITRepo *)theRepo error: (NSError **)error;

@end
