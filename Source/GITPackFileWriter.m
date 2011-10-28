//
//  GITPackFileWriter.m
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackFileWriter.h"
#import "GITPackFileWriterPlaceholder.h"
#import "GITRevList.h"


@implementation GITPackFileWriter

#pragma mark Class Cluster Methods
+ (id)alloc {
    if ([self isEqual:[GITPackFileWriter class]])
        return [GITPackFileWriterPlaceholder alloc];
    else return [super alloc];
}
+ (id)allocWithZone: (NSZone *)zone {
    if ([self isEqual:[GITPackFileWriter class]])
        return [GITPackFileWriterPlaceholder allocWithZone:zone];
    else return [super allocWithZone:zone];
}
- (id)copyWithZone: (NSZone *)zone {
    return self;
}

#pragma mark Class Initialisers
+ (GITPackFileWriter *)packWriter {
    return [[[self alloc] initWithDefaultVersion] autorelease];
}
+ (GITPackFileWriter *)packWriterVersion: (NSUInteger)version {
    return [[[self alloc] initWithVersion:version error:NULL] autorelease];
}

#pragma mark Initialisers
- (id)initWithDefaultVersion {
    [self doesNotRecognizeSelector: _cmd];
    [self release];
    return nil;
}
- (id)initWithVersion: (NSUInteger)version error: (NSError **)error {
    [self doesNotRecognizeSelector: _cmd];
    [self release];
    return nil;
}

#pragma mark Add Objects to PACK
- (void)addObjectsFromCommit: (GITCommit *)commit {
    return [self addObjectsFromRevList:[GITRevList revListWithCommit:commit]];
}

#pragma mark PACK File Naming
- (NSString *)fileName {
    return [NSString stringWithFormat:@"pack-%@.pack", [self name]];
}

#pragma mark Un-implemented Instance Methods
- (NSInteger)writeToStream: (NSOutputStream *)stream {
    [self doesNotRecognizeSelector: _cmd];
    return -1;
}
- (GITPackIndexWriter *)indexWriter {
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}
- (void)setIndexWriter: (GITPackIndexWriter *)indexWriter {
    [self doesNotRecognizeSelector: _cmd];
}
- (void)addObjectsFromRevList: (GITRevList *)revList {
    [self doesNotRecognizeSelector: _cmd];
}
- (NSString *)name {
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

#pragma mark NSRunLoop method
- (void)writeToStream: (NSOutputStream *)stream inRunLoop: (NSRunLoop *)runLoop {
    [stream setDelegate:self];
    [stream scheduleInRunLoop:runLoop forMode:NSDefaultRunLoopMode];
    [stream open];
}
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    switch ( eventCode ) {
        case NSStreamEventHasSpaceAvailable:
            [self writeToStream:(NSOutputStream *)stream];
            break;
        case NSStreamEventErrorOccurred:
            // should really handle this
            break;
    }
}

#pragma mark Polling Method
- (NSInteger)writeToStream: (NSOutputStream *)stream error: (NSError **)error {
    [stream open];

    while ( [stream hasSpaceAvailable] ) {
        if ( [self writeToStream:stream] < 0 ) {
            if ( error ) *error = [stream streamError];
            return -1;
        }
    }

    return 0;
}

@end
