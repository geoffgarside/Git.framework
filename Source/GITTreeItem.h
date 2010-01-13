//
//  GITTreeItem.h
//  Git.framework
//
//  Created by Geoff Garside on 14/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    GITTreeItemModeType = 00170000,
    GITTreeItemModeLink =  0120000,
    GITTreeItemModeFile =  0100000,
    GITTreeItemModeDir  =  0040000,
    GITTreeItemModeMod  =  0160000,
} GITTreeItemMode;

@class GITTree, GITObjectHash, GITObject;

/*!
 * The GITTreeItem class represents the information stored in a GITree object.
 *
 * GITTrees are made up of items specifying the mode, name and SHA1 reference
 * of objects which are part of that tree. The GITTree parses the items of its
 * object data and creates and array of GITTreeItem objects. The Tree Item is
 * then capable of lazily loading the target objects of the reference.
 */
@interface GITTreeItem : NSObject {
    GITTree *parent;        //!< Tree the item belongs to
    GITTreeItemMode mode;   //!< File/directory mode of the item
    NSString  *name;        //!< Name of the file or directory
    GITObject *item;        //!< Item being pointed to
    GITObjectHash *sha1;    //!< Hash of the item (tree/blob) referred to
}

//! \name Properties
@property (retain) GITTree *parent;
@property (assign) GITTreeItemMode mode;
@property (copy) NSString *name;
@property (retain) GITObject *item;
@property (retain) GITObjectHash *sha1;

//! \name Creating and Initialising Tree Items
/*!
 * Creates and returns a tree content item with the \a mode, \a name and \a sha1.
 *
 * \param tree The tree the item is a part of
 * \param mode The file mode of the object referenced
 * \param name The name of the object referenced
 * \param sha1 The sha1 of the object referenced
 * \return a tree item object
 * \sa initInTree:withMode:name:sha1:
 */
+ (GITTreeItem *)itemInTree: (GITTree *)tree withMode: (GITTreeItemMode)mode name: (NSString *)name sha1: (GITObjectHash *)sha1;

/*!
* Creates and returns a tree content item with the \a mode, \a name and \a sha1.
*
* \param tree The tree the item is a part of
* \param mode The file mode of the object referenced
* \param name The name of the object referenced
* \param sha1 The sha1 of the object referenced
* \return a tree item object
* \sa itemInTree:withMode:name:sha1:
 */
- (id)initInTree: (GITTree *)tree withMode: (GITTreeItemMode)mode name: (NSString *)name sha1: (GITObjectHash *)sha1;

@end
