//
//  GITTreeItem.h
//  Git.framework
//
//  Created by Geoff Garside on 14/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    GITTreeItemModeType = 0x00170000,
    GITTreeItemModeLink =  0x0120000,
    GITTreeItemModeFile =  0x0100000,
    GITTreeItemModeDir  =  0x0040000,
    GITTreeItemModeMod  =  0x0160000,
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
    NSUInteger mode;        //!< File/directory mode of the item
    NSString  *name;        //!< Name of the file or directory
    GITObject *item;        //!< Item being pointed to
    GITObjectHash *sha1;    //!< Hash of the item (tree/blob) referred to
}

//! \name Properties
@property (retain) GITTree *parent;
@property (assign) NSUInteger mode;
@property (copy)   NSString *name;
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
+ (GITTreeItem *)itemInTree: (GITTree *)tree withMode: (NSUInteger)mode name: (NSString *)name sha1: (GITObjectHash *)sha1;

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
- (id)initInTree: (GITTree *)tree withMode: (NSUInteger)mode name: (NSString *)name sha1: (GITObjectHash *)sha1;

//! \name Item Mode Tests
/*!
 * Indicates if the receiver represents a link.
 *
 * \return YES if the receiver represents a link, NO if not
 */
- (BOOL)isLink;

/*!
 * Indicates if the receiver represents a file (blob).
 *
 * \return YES if the receiver represents a file, NO if not
 */
- (BOOL)isFile;

/*!
 * Indicates if the receiver represents a directory (tree).
 *
 * \return YES if the receiver represents a directory, NO if not
 */
- (BOOL)isDirectory;

/*!
 * Indicates if the receiver represents a submodule.
 *
 * \return YES if the receiver represents a submodule, NO if not
 */
- (BOOL)isModule;

//! \name Testing Equality
/*!
 * Returns a Boolean value that indicates whether the receiver and a given object are equal.
 *
 * \param other The object to be compared to the receiver
 * \return YES if the receiver and other are equal, otherwise NO
 * \sa isEqualToTreeItem:
 * \sa isEqualToObject:
 */
- (BOOL)isEqual: (id)other;

/*!
 * Returns a Boolean value that indicates whether the receiver and a given Tree Item are equal.
 *
 * \param rhs The Tree Item with which to compare the receiver
 * \return YES if the receiver and hash are equal, otherwise NO
 * \sa isEqual:
 * \sa isEqualToObject:
 */
- (BOOL)isEqualToTreeItem: (GITTreeItem *)rhs;

/*!
 * Returns a Boolean value that indicates whether the receiver and a given GITObject are equal.
 *
 * \param rhs The GITObject with which to compare the receiver
 * \return YES if the receiver and hash are equal, otherwise NO
 * \sa isEqual:
 * \sa isEqualToTreeItem:
 */
- (BOOL)isEqualToObject: (GITObject *)rhs;

@end
