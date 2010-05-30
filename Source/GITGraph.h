//
//  GITGraph.h
//  Git.framework
//
//  Created by Geoff Garside on 26/04/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITGraphNode, GITCommit;

/*!
 * The Graph class manages a graph of nodes and edges for searching
 * and sorting of those nodes.
 *
 * \author Brian Chapados
 */
@interface GITGraph : NSObject {
    NSMutableDictionary *nodes;     //!< Nodes in the graph
    NSUInteger edgeCounter;         //!< Number of edges defined in the graph
}

//! \name Creating and Initialising Graphs
/*!
 * Creates and returns a new empty graph object.
 *
 * \return New graph object
 * \sa init
 */
+ (GITGraph *)graph;

/*!
 * Creates and returns a new graph object populated with nodes from the given \a commit.
 *
 * The commit history from the \a commit given is iterated and for each commit found
 * a new node is added to the graph.
 *
 * \param commit GITCommit object to populate the graph from
 * \return New graph object populated with the history of the given \a commit.
 * \sa initWithStartingCommit:
 * \sa buildWithStartingCommit:
 */
+ (GITGraph *)graphWithStartingCommit: (GITCommit *)commit;

/*!
 * Initialises and returns an empty graph object.
 *
 * \return initialised graph object
 */
- (id)init;

/*!
 * Initialises and returns a graph object populated with nodes from the given \a commit.
 *
 * The commit history from the \a commit given is iterated and for each commit found
 * a new node is added to the graph.
 *
 * \param commit GITCommit object to populate the graph from
 * \return initialised graph object populated with the history of the given \a commit.
 * \sa buildWithStartingCommit:
 */
- (id)initWithStartingCommit: (GITCommit *)commit;

//! \name Testing for Nodes
/*!
 * Checks if the \a node is present in the receiver.
 *
 * \param node Node to check for
 * \return Boolean YES if the \a node is in the graph, NO if not.
 */
- (BOOL)hasNode: (GITGraphNode *)node;

//! \name Adding and Removing Nodes and Edges
/*!
 * Adds a \a node to the receiver.
 *
 * \param node GITGraphNode to add to the receiver.
 */
- (void)addNode: (GITGraphNode *)node;

/*!
 * Removes a \a node from the receiver.
 *
 * \param node GITGraphNode to remove from the receiver.
 */
- (void)removeNode: (GITGraphNode *)node;

/*!
 * Add an edge between nodes \a fromNode and \a toNode in the receiver.
 *
 * \param fromNode Graph node to create the edge from
 * \param toNode Graph node to create the edge to
 */
- (void)addEdgeFromNode: (GITGraphNode *)fromNode to: (GITGraphNode *)toNode;

/*!
 * Removes an edge between nodes \a fromNode and \a toNode in the receiver.
 *
 * \param fromNode Graph node to remove the edge from
 * \param toNode Graph node to remove the edge to
 */
- (void)removeEdgeFromNode: (GITGraphNode *)fromNode to: (GITGraphNode *)toNode;

//! \name Finding Nodes
/*!
 * Returns the node identified by the given \a key in the receiver.
 *
 * \param key Key to identify the node in the receiver.
 * \return Graph node object identified by the given \a key, or nil if not found.
 */
- (GITGraphNode *)nodeWithKey: (id)key;

//! \name Graph Information
/*!
 * Returns the number of nodes in the receiver
 *
 * \return number of nodes in the receiver
 */
- (NSUInteger)nodeCount;

/*!
 * Returns the number of edges in the receiver.
 *
 * \return number of edges in the receiver
 */
- (NSUInteger)edgeCount;

//! \name Populating the Graph
/*!
 * Populates the receiver with nodes from the history of the given \a commit
 *
 * \return commit Commit object to populate the receiver from
 */
- (void)buildWithStartingCommit: (GITCommit *)commit;

//! \name Sorting Nodes of a Graph
/*!
 * Returns an array of nodes of the receiver sorted by date.
 *
 * \return array of nodes of the receiver sorted by date
 */
- (NSArray *)arrayOfNodesSortedByDate;

/*!
 * Returns an array of nodes of the receiver sorted by toplogy
 *
 * \return array of nodes of the receiver sorted by toplogy
 */
- (NSArray *)arrayOfNodesSortedByTopology;

/*!
 * Returns an array of nodes of the receiver sorted by toplogy and date
 *
 * \return array of nodes of the receiver sorted by toplogy and date
 */
- (NSArray *)arrayOfNodesSortedByTopologyAndDate;

@end
