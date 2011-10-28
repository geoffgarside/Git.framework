//
//  GITGraphNode.h
//  Git.framework
//
//  Created by Geoff Garside on 27/04/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * A Graph Node is used with a Graph to store objects to be sorted.
 *
 * If the object responds to <tt>committerDate</tt> then the return value of
 * this method will be stored in the nodes <tt>time</tt> field which is
 * required for date based sorting.
 *
 * \author Brian Chapados
 */
@interface GITGraphNode : NSObject {
    id key;                             //!< Node key
    id object;                          //!< Node object

    BOOL visited;                       //!< Flag indicating if the node has been visited
    BOOL processed;                     //!< Flag indicating if the node has been processed

    // Non retaining arrays
    CFMutableArrayRef inbound;          //!< Array of inbound nodes, ie the edges
    CFMutableArrayRef outbound;         //!< Array of outbound nodes, ie the edges

    NSUInteger inboundEdgeCount;        //!< Count of the number of inbound edges
    NSUInteger outboundEdgeCount;       //!< Count of hte numerb of outbound edges

    NSTimeInterval time;                //!< Time of the object of the node
}

//! \name Properties
@property (readonly,copy) id key;
@property (readonly,assign) id object;
@property (readonly,assign) BOOL visited;

//! \name Creating and Initialising Nodes
/*!
 * Creates and returns a node with the \a object and \a key.
 *
 * \param object Object to create the node with
 * \param key Key to identify the node
 * \return new node with the \a object and \a key
 */
+ (GITGraphNode *)nodeWithObject: (id)object key: (id)key;

/*!
 * Initialises and returns a node with the \a object and \a key.
 *
 * \param object Object to create the node with
 * \param key Key to identify the node
 * \return initialised node with the \a object and \a key
 */
- (id)initWithObject: (id)object key: (id)key;

//! \name Flags
/*!
 * Reset the flags on the receiver to defaults
 */
- (void)resetFlags;

/*!
 * Returns the visited state of the receiver.
 *
 * \return visited state of the receiver
 */
- (BOOL)hasBeenVisited;

/*!
 * Marks the receiver as visited.
 */
- (void)markVisited;

/*!
 * Returns the processed state of the receiver.
 *
 * \return processed state of the receiver
 */
- (BOOL)hasBeenProcessed;

/*!
 * Marks the receiver as processed.
 */
- (void)markProcessed;

//! \name Adding and Removing Edges
/*!
 * Add inbound edge from the receiver to the \a node.
 *
 * \param node Node to create the edge to
 */
- (void)addInboundEdgeToNode: (GITGraphNode *)node;

/*!
 * Add outbound edge from the receiver to the \a node.
 *
 * \param node Node to create the edge to
 */
- (void)addOutboundEdgeToNode: (GITGraphNode *)node;

/*!
 * Remove inbound edge from the receiver to the \a node.
 *
 * \param node Node to remove the edge to
 */
- (void)removeInboundEdgeToNode: (GITGraphNode *)node;

/*!
 * Remove outbound edge from the receiver to the \a node.
 *
 * \param node Node to remove the edge to
 */
- (void)removeOutboundEdgeToNode: (GITGraphNode *)node;

//! \name Edge Counts
/*!
 * Reset the inbound edge count to the number of nodes in the inbound list.
 */
- (void)resetInboundEdgeCount;

/*!
 * Reset the outbound edge count to the number of nodes in the outbound list.
 */
- (void)resetOutboundEdgeCount;

/*!
 * Return the count of inbound edges.
 *
 * \return number of inbound edges
 */
- (NSUInteger)inboundEdgeCount;

/*!
 * Return the count of outbound edges.
 *
 * \return number of outbound edges
 */
- (NSUInteger)outboundEdgeCount;

/*!
 * Decrements and returns the inbound edge count.
 *
 * \return decremented inbound edge count
 */
- (NSUInteger)decrementedInboundEdgeCount;

/*!
 * Decrements and returns the outbound edge count.
 *
 * \return decremented outbound edge count
 */
- (NSUInteger)decrementedOutboundEdgeCount;

//! \name Inbound and Outbound Nodes
/*!
 * Returns the array of inbound nodes the receiver has edges to.
 *
 * \return array of inbound nodes the receiver has edges to
 */
- (NSArray *)inboundNodes;

/*!
 * Returns the array of outbound nodes the receiver has edges to.
 *
 * \return array of outbound nodes the receiver has edges to
 */
- (NSArray *)outboundNodes;

//! \name Equality and Comparison
/*!
 * Tests if the receiver is equal to the \a other object.
 *
 * \param other Object to compare the receiver to
 * \return YES if the reciever is equal to the \a other object, NO if not
 */
- (BOOL)isEqual: (id)other;

/*!
 * Compares the receiver to the \a rhs node object.
 *
 * \param rhs Other graph node to compare the receiver to
 * \return NSComparisonResult if the comparison
 */
- (NSComparisonResult)compare: (GITGraphNode *)rhs;

@end
