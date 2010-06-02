//
//  GITObject.h
//  Git.framework
//
//  Created by Geoff Garside on 08/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    GITObjectTypeUnknown = 0,
    GITObjectTypeCommit  = 1,
    GITObjectTypeTree    = 2,
    GITObjectTypeBlob    = 3,
    GITObjectTypeTag     = 4,
} GITObjectType;

@class GITObjectHash, GITRepo;

/*!
 * Protocol for children of the GITObject class to implement.
 *
 * The protocol defines the methods which a GITObject child should implement
 * but which are not really appropriate to be defined within the GITObject
 * class itself.
 */
@protocol GITObject <NSObject>

//! \name Type translations
/*!
 * Returns the string type of the receiving GITObject child class.
 *
 * \return string type of the receiver
 * \sa type
 */
+ (NSString *)typeName;

/*!
 * Returns the GITObjectType of the receiving GITObject child class.
 *
 * \return GITObjectType of the receiver
 * \sa typeName
 */
+ (GITObjectType)type;

//! \name Initialisers
/*!
 * Creates and returns an instance of the receiving class.
 *
 * The \a data contains the representation of the object to create, the \a repo
 * specifies the parent repository and where any additional objects associated
 * with the object may be loaded from.
 *
 * \param data Data containing the representation of the object to create
 * \param objectHash The SHA1 hash of the receiver
 * \param repo Repository parent of the object
 * \param[out] error NSError describing any errors which occurred
 * \return Instance of the receiving class
 */
- (id)initFromData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)repo error: (NSError **)error;

@end

/*!
 * GITObject is an \e abstract class which provides fields and methods common to all
 * inheriting classses.
 *
 * The GITObject
 */
@interface GITObject : NSObject {
    GITObjectType  type;        //!< Type of the object
    GITObjectHash *sha1;        //!< SHA1 hash of the object
    GITRepo *repo;              //!< The repository the object is part of
    NSUInteger size;            //!< The size of the object
}

//! \name Properties
@property (assign) GITObjectType  type;
@property (retain) GITObjectHash *sha1;
@property (retain) GITRepo *repo;
@property (assign) NSUInteger size;

//! \name Object Type to String Conversion
/*!
 * Returns the string equivalent of the \a type.
 *
 * \param type GITObjectType to convert to a string
 * \return String equivalent to the \a type
 * \sa objectTypeForString:
 */
+ (NSString *)stringForObjectType: (GITObjectType)type;

/*!
 * Returns the GITObjectType equivalent of the \a type.
 *
 * \param type String to convert to a GITObjectType value
 * \return GITObjectType equivalent to the \a type
 * \sa stringForObjectType:
 */
+ (GITObjectType)objectTypeForString: (NSString *)type;

/*!
 * Creates and returns an object of the \a type specified composed of the \a data within the \a repo.
 *
 * In the event that an error occurrs while creating the object the \a error will describe the nature of the
 * error which occurred.
 *
 * This method is essentially a dispatcher, based on the \a type provided the default initializer for the
 * correct GITObject subtype will be called to create the correct representation and return the new object.
 *
 * \param type The type of the object to create
 * \param data The data composing the object
 * \param objectHash The SHA1 hash of the object
 * \param repo The repository the object is a member of
 * \param error NSError describing the error which occurred
 * \return object from the \a type from the \a data
 */
+ (id)objectOfType: (GITObjectType)type withData: (NSData *)data sha1: (GITObjectHash *)objectHash repo: (GITRepo *)repo error: (NSError **)error;

/*!
 * Returns a GITObject initialised with the \a type, \a objectHash and \a repo.
 *
 * This method is intended to be used by the git object type classes initialiser methods [super init...] call, the
 * purpose is to initialise the fields common to all of the GITObject children.
 *
 * \param type Type of object
 * \param objectHash Hash of the object
 * \param repo Repository the object is a member of
 * \return object initialised with the provided values
 */
- (id)initWithType: (GITObjectType)type sha1: (GITObjectHash *)objectHash repo: (GITRepo *)repo;

//! \name Object Comparison
/*!
* Returns a Boolean value that indicates whether the receiver and a given object are equal.
*
* \param other The object to be compared to the receiver
* \return YES if the receiver and other are equal, otherwise NO
* \sa isEqualToObject:
 */
- (BOOL)isEqual: (id)other;

/*!
* Returns a Boolean value that indicates whether the receiver and a given Object are equal.
*
* \param object The Object with which to compare the receiver
* \return YES if the receiver and hash are equal, otherwise NO
* \sa isEqual:
 */
- (BOOL)isEqualToObject: (GITObject *)object;

@end
