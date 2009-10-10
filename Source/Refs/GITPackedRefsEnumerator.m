//
//  GITPackedRefsEnumerator.m
//  Git.framework
//
//  Created by Geoff Garside on 04/10/2009.
//  Copyright 2009 Geoff Garside. All rights reserved.
//

#import "GITPackedRefsEnumerator.h"
#import "GITRepo.h"
#import "NSData+Searching.h"


@interface GITPackedRefsEnumerator ()
@property (copy) NSString *packedRefsPath;
@property (retain) NSData *packedRefs;
@end

@implementation GITPackedRefsEnumerator

@synthesize packedRefsPath, packedRefs;

+ (GITPackedRefsEnumerator *)enumeratorForRepo: (GITRepo *)theRepo {
    return [[[[self class] alloc] initWithRepo:theRepo] autorelease];
}

- (id)initWithRepo: (GITRepo *)theRepo {
    if ( ![super init] )
        return nil;

    started = NO;
    hasPackedRefs = NO;    // assume the worst
    self.packedRefsPath = [theRepo.root stringByAppendingPathComponent:@"packed-refs"];

    BOOL isDirectory;
    if ( [[NSFileManager defaultManager] fileExistsAtPath:self.packedRefsPath isDirectory:&isDirectory] && !isDirectory ) {
        hasPackedRefs = YES;
    }

    return self;
}

- (void)dealloc {
    self.packedRefsPath = nil;
    self.packedRefs = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark NSEnumerator Methods
- (NSArray *)allObjects {
    if ( !hasPackedRefs )
        return [NSArray array];

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];

    id packedRef;
    while ( packedRef = [self nextObject] ) {
        [array addObject:packedRef];
    }

    return [NSArray arrayWithArray:array];
}

- (id)nextObject {
    if ( !hasPackedRefs )
        return nil;

    if ( !started ) {
        self.packedRefs = [NSData dataWithContentsOfFile:self.packedRefsPath options:NSDataReadingMapped error:NULL];
        currentRange = NSMakeRange(0, 0);
        started = YES;
    }

    if ( !self.packedRefs )
        return nil;

    currentRange = [self.packedRefs rangeFrom:(currentRange.location + currentRange.length) toByte:'\n'];
    if ( currentRange.location == NSNotFound || currentRange.location + currentRange.length > [self.packedRefs length] )
        return nil;

    NSData *packedRefData = [self.packedRefs subdataWithRange:currentRange];
    NSString *packedRefLine = [[NSString alloc] initWithData:packedRefData encoding:NSUTF8StringEncoding];

    currentRange.length += 1; // move length past the \n

    if ( [packedRefLine hasPrefix:@"#"] ) {
        [packedRefLine release];
        return [self nextObject];
    }

    return [packedRefLine autorelease];
}

// Included in case we need to add our own NSFastEnumeration implementation
//#pragma mark -
//#pragma mark NSFastEnumerator Methods
//- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
//    
//}

@end
