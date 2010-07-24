//
//  GITRevList.h
//  Git.framework
//
//  Created by Geoff Garside on 11/07/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITCommit, GITGraph;
@interface GITRevList : NSObject {
    GITGraph *graph;
}

+ (GITRevList *)revListWithCommit: (GITCommit *)head;

- (id)initWithCommit: (GITCommit *)head;

- (void)subtractDescendentsFromCommit: (GITCommit *)tail;

- (NSArray *)arrayOfCommitsSortedByDate;
- (NSArray *)arrayOfCommitsSortedByTopology;
- (NSArray *)arrayOfCommitsSortedByTopologyAndDate;

@end
