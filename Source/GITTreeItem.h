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
@interface GITTreeItem : NSObject {
    GITTree *parent;        //!< Tree the item belongs to
    GITTreeItemMode mode;   //!< File/directory mode of the item
    NSString  *name;        //!< Name of the file or directory
    GITObject *item;        //!< Item being pointed to
    GITObjectHash *sha1;    //!< Hash of the item (tree/blob) referred to
}

@property (retain) GITTree *parent;
@property (assign) GITTreeItemMode mode;
@property (copy) NSString *name;
@property (retain) GITObject *item;
@property (retain) GITObjectHash *sha1;

+ (GITTreeItem *)itemInTree: (GITTree *)tree withMode: (GITTreeItemMode)mode name: (NSString *)name sha1: (GITObjectHash *)sha1;

- (id)initInTree: (GITTree *)tree withMode: (GITTreeItemMode)mode name: (NSString *)name sha1: (GITObjectHash *)sha1;

@end
