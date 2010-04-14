//
//  GITObject+Parsing.h
//  Git.framework
//
//  Created by Geoff Garside on 13/12/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GITObject.h"


typedef struct {
    char *startPattern;         //!< String to match at the start of the buffer
    NSUInteger patternLen;      //!< Length of startPattern
    NSInteger startLen;         //!< 
    NSUInteger matchLen;        //!< Length of the target string or ZERO if unknown
    char endChar;               //!< Character to terminate matching at, must be set, -1 if you don't care
                                //!< in which case matchLen must be set
} parsingRecord;

/*!
 * Parses the \a buffer in accordance with the \a record, returning the string range by \a matchStart and \a matchLen.
 *
 * \param buffer
 * \param record
 * \param[out] matchStart
 * \param[out] matchLength
 * \return BOOL indicating if a matching record was found, \a matchStart & \a matchLength contain the string range
 */
BOOL parseObjectRecord(const char **buffer, parsingRecord record, const char **matchStart, NSUInteger *matchLength);

/*!
 * This category provides parsing abilities to the GITObject class. These are intended to be used by the
 * GITObject descendent classes to parse their contents.
 *
 * <h1>Parsing Known Length String</h1>
 * In some cases you will know prior to parsing the length of the string you need to find. For example we have a buffer
 * <tt>"foo bar\n"</tt>, in this case we want the \c "bar" string. But we don't know its \c "bar", but we do know that it is
 * three characters long, is prefixed with \c "foo " and ends with \c "\n". To detect the starting point of \c "bar" and how
 * long it is we need to use a \c parsingRecord structure <tt>{ "foo ", 4, 4, 3, '\\n' }</tt>. So we have the starting
 * pattern \c "foo " and the length of that pattern which is 4. The third field indicates that matching needs to start from
 * the 4th character in the buffer. The fourth field indicates how long the match will be and the last field is the
 * terminating character, in this case a new line. Given the match length is known an error will be returned if the ending
 * character does not match the character \c matchLen characters from the start position.
 *
 * <h1>Parsing Unknown Length Strings</h1>
 * When the length of the target string is not known the use is similar to the known length parsing with the exception that
 * the <tt>.startLen</tt> field of the \c parsingRecord will be set to zero to allow for automatic determination of the end
 * of the match based on the <tt>.endChar</tt> field. Taking the known length example but the length of \c "bar" is unknown
 * but the ending character is known. In this case the \c parsingRecord structure would need to be initialised to the following
 * <tt>{ "foo ", 4, 4, 0, '\\n' }</tt> to permit the detection of the ending character to terminate the match.
 *
 * <h1>Parsing Ends of Strings</h1>
 * Parsing the ends of strings has one primary limitation at this time, the length of the suffix must be known. This is due
 * to the way in which the <tt>.startLen</tt> field of the \c parsingRecord structure is used, this limitation may be removed
 * if there is a great need for it. The parsing of string suffixes uses a negative value <tt>.startLen</tt> field and the
 * ending character to find the end and thereby the start of the match. The <tt>.matchLen</tt> field may be specified to
 * enable matching only a specific set of the characters from the determined match start. As an example we have a string
 * <tt>"foo bar 1262562908 +0000\n"</tt> and the desired match is <tt>1262562908</tt>. Additionally we only know the prefix
 * of the string is \c "foo " and the \c "bar" section can be of any length. In this case we have to make a match on the end
 * of the string. To obtain this match a \c parsingRecord structure of <tt>{ "foo ", 4, -17, 10, '\\n' }</tt> would be specified.
 * The <tt>.startLen</tt> causes the determined starting point to fall on the \c 1 of \c 1262562908 and the <tt>.matchLen</tt>
 * limits the match end to the \c ' ' character after the \c 8 in \c 1262562908. If the <tt>"+0000"</tt> was later wanted a
 * similar \c parsingRecord structure of <tt>{ "foo ", 4, -7, 5, '\\n' }</tt> would be specified, though the <tt>.matchLen</tt>
 * could also be set to 0 in this case.
 *
 * <h1>Parsing Strings without a Known End Character</h1>
 * There are also cases where the length of the match is known but there is no end terminating character, an example of this
 * is `tree` objects in git repositories. These consist of a number of entries all butted up together with a known length string
 * as the last part of the entry. In this case the <tt>.endChar</tt> can be set to \c -1. This prevents the \c endChar from being
 * matched and also prevents the provided buffers position from being moved past the end of the matched string. To match a string
 * like this a \c parsingRecord structure such as <tt>{ "foo ", 4, 4, 20, -1 }</tt> to match the the last twenty characters of the
 * string starting with \c "foo ".
 *
 * \author Brian Chapados
 */
@interface GITObject (Parsing)

//! \name Matching Object Hashes
/*!
 * Creates and returns a GITObjectHash matching the specified \a record
 *
 * This method creates a GITObjectHash directly from the raw bytes corresponding
 * to the git object id record. It bypasses the unnecessary step of allocating
 * and initializing an NSString object, which is expensive when called repeatedly
 * during high-load git object graph parsing operations. During object parsing,
 * the expected type of the underlying data is typically known, and this method
 * allows that information to be utilized for performance gains.
 *
 * Use this method to directly parse the git object id (hash) record for an
 * object.
 * \param record Record describing the string to match
 * \param bytes Pointer to the byte stream to search. This byte stream should
 *        be either an unpacked sha1 string (40 bytes) or packed SHA1 data (20 bytes)
 * \return GITObjectHash object matching the \a record or nil if no match
 * \sa newStringWithObjectRecord:bytes:encoding:
 */
- (GITObjectHash *)newObjectHashWithObjectRecord: (parsingRecord)record bytes:(const char **)bytes;

//! \name Matching Strings
/*!
 * Creates and returns a string matching the format defined by the \a record.
 *
 * \param record Record describing the string to match
 * \param bytes Pointer to the byte stream to search
 * \return string matching the \a record or nil if no match
 * \sa newStringWithObjectRecord:bytes:encoding:
 */
- (NSString *)newStringWithObjectRecord: (parsingRecord)record bytes: (const char **)bytes;

/*!
 * Creates and returns a string matching the format defined by the \a record. 
 *
 * \param record Record describing the string to match
 * \param bytes Pointer to the byte stream to search
 * \param encoding NSStringEncoding to interpret the bytes with when creating the string
 * \return string matching the \a record or nil if no match
 * \sa newStringWithObjectRecord:bytes:
 */
- (NSString *)newStringWithObjectRecord: (parsingRecord)record bytes: (const char **)bytes encoding: (NSStringEncoding)encoding;

@end
