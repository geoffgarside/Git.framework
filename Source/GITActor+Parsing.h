//
//  GITActor+Parsing.h
//  Git.framework
//
//  Created by Geoff Garside on 10/01/2010.
//  Copyright 2010 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GITActor.h"


/*!
 * This category provides additional initialisers for GITActor.
 *
 * These initialisers aid in creating GITActor objects from the kind of
 * content typically retrieved by the GITObject(Parsing) category methods.
 */
@interface GITActor (Parsing)

//! \name Creating and Initialising Actors from Parsed Strings
/*!
 * Creates and returns an actor object by parsing the name and email from
 * a string contained in a GITCommit header (author or committer) line.
 *
 * This method expects pre-processed input of the form: "[name] <[email]".
 * example: "E. L. Gato <elgato@catz.com"
 * where name and email are separated by the string " <"
 *
 * \param str A preprocessed string of the form "[name] <[email]"
 * \return An actor object with the extracted name and email.
 * \sa initWithParsedString:
 */
+ (GITActor *)actorWithParsedString: (NSString *)str;

/*!
 * Creates and returns an actor object by parsing the name and email from
 * a string contained in a GITCommit header (author or committer) line.
 *
 * This method expects pre-processed input of the form: "[name] <[email]".
 * example: "E. L. Gato <elgato@catz.com"
 * where name and email are separated by the string " <"
 *
 * \param str A preprocessed string of the form "[name] <[email]"
 * \return An actor object with the extracted name and email.
 * \sa actorWithParsedString:
 */
- (id)initWithParsedString: (NSString *)str;

@end
