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
 * Tree objects store the file system structure of a repository at the
 * point at which the tree is created. They represent directories or
 * folders and contain references to items in the directory/folder which
 * may be other trees, directory/folder, or blobs, files.
 *
 * Tree objects store a list of directory items with their associated
 * modes and SHA1 references. The SHA1 references are in the packed form.
 * \verbatim
 * 100644 .gitignore a5cc2925ca8258af241be7e5b0381edf30266302
 * 100644 README 69e27356ef629022720d868ab0c0e3394775b6c1
 * \endverbatim
 */
@interface GITTree : GITObject <GITObject> {
    NSArray *items;     //!< The items in the tree
}

//! \name Properties
@property (copy) NSArray *items;

//! \name Creating and Initialising Trees
/*!
 * Creates and returns a tree from the \a data.
 *
 * The \a data is parsed to extract the references to the tree contents, the
 * contents are then stored in the \c items array as GITTreeItem objects.
 *
 * \param data The data to create the tree from
 * \param objectHash The SHA1 hash of the receiver
 * \param repo The repository the tree is a member of
 * \param error NSError describing any errors which occurred
 * \return A tree object
 */
+ (GITTree *)treeFromData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)repo error: (NSError **)error;

@end
