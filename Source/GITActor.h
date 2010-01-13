//
//  GITActor.h
//  Git.framework
//
//  Created by Geoff Garside on 10/01/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * This class describes people who have made a contribution to a repository.
 *
 * People are committers and authors, they have names and e-mail addresses,
 * this class collects these two pieces of information.
 */
@interface GITActor : NSObject {
    NSString *name;         //!< Name of the actor
    NSString *email;        //!< Email address of the actor
}

//! \name Properties
@property (copy) NSString *name;
@property (copy) NSString *email;

//! \name Creating and Initialising Actors
/*!
 * Creates and returns an unknown actor.
 *
 * The name by default is "User" and the email address is derived from the
 * current process environment \c USER and \c HOST variables.
 *
 * \return unknown actor
 * \sa actorWithName:email:
 */
+ (GITActor *)actor;

/*!
 * Creates and returns an actor with the \a name.
 *
 * The email address is derived from the current process environment \c USER
 * and \c HOST variables.
 *
 * \param name Name of the actor
 * \return actor with \a name
 * \sa initWithName:
 */
+ (GITActor *)actorWithName: (NSString *)name;

/*!
 * Creates and returns an actor with the \a name and \a email.
 *
 * \param name Name of the actor
 * \param email Email address of the actor
 * \return actor with \a name and \a email
 * \sa initWithName:email:
 */
+ (GITActor *)actorWithName: (NSString *)name email: (NSString *)email;

/*!
 * Creates and returns an actor with the \a name.
 *
 * The email address is derived from the current process environment \c USER
 * and \c HOST variables.
 *
 * \param name Name of the actor
 * \return actor with \a name
 * \sa initWithName:email:
 */
- (id)initWithName: (NSString *)name;

/*!
 * Creates and returns an actor with the \a name and \a email.
 *
 * \param name Name of the actor
 * \param email Email address of the actor
 * \return actor with \a name and \a email
 */
- (id)initWithName: (NSString *)name email: (NSString *)email;

@end
