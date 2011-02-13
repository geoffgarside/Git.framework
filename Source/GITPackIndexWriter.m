//
//  GITPackIndexWriter.m
//  Git.framework
//
//  Created by Geoff Garside on 05/02/2011.
//  Copyright 2011 Geoff Garside. All rights reserved.
//

#import "GITPackIndexWriter.h"
#import "GITPackIndexWriterPlaceholder.h"


@implementation GITPackIndexWriter

#pragma mark Class Cluster Methods
+ (id)alloc {
    if ([self isEqual:[GITPackIndexWriter class]])
        return [GITPackIndexWriterPlaceholder alloc];
    else return [super alloc];
}
+ (id)allocWithZone: (NSZone *)zone {
    if ([self isEqual:[GITPackIndexWriter class]])
        return [GITPackIndexWriterPlaceholder allocWithZone:zone];
    else return [super allocWithZone:zone];
}
- (id)copyWithZone: (NSZone *)zone {
    return self;
}

#pragma mark Class Initialisers
+ (GITPackIndexWriter *)indexWriter {
    return [[[self alloc] initWithDefaultVersion] autorelease];
}
+ (GITPackIndexWriter *)indexWriterVersion: (NSUInteger)version {
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

#pragma mark Un-implemented Instance Methods
- (void)addObjectWithName: (GITObjectHash *)sha1 andData: (NSData *)data atOffset: (NSUInteger)offset {
    [self doesNotRecognizeSelector: _cmd];
    return;
}
- (void)addPackChecksum: (NSData *)packChecksumData {
    [self doesNotRecognizeSelector: _cmd];
    return;
}
- (NSInteger)writeToStream: (NSOutputStream *)stream {
    [self doesNotRecognizeSelector: _cmd];
    return -1;
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
