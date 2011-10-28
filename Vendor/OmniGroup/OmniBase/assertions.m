// Copyright 1997-2006, 2008-2009 Omni Development, Inc.  All rights reserved.
//
// This software may only be used and reproduced according to the
// terms in the file OmniSourceLicense.html, which should be
// distributed with this project and can also be found at
// <http://www.omnigroup.com/developer/sourcecode/sourcelicense/>.

#import "assertions.h"
#import <Foundation/Foundation.h>
#import "OBUtilities.h"
#import "OBBacktraceBuffer.h"
#import <unistd.h> // For getpid()

#ifdef OMNI_ASSERTIONS_ON

BOOL OBEnableExpensiveAssertions = NO;

void OBLogAssertionFailure(const char *type, const char *expression, const char *file, unsigned int lineNumber)
{
    fprintf(stderr, "%s failed: requires '%s', at %s:%d\n", type, expression, file, lineNumber);
}

static NSString *OBShouldAbortOnAssertFailureEnabled = @"OBShouldAbortOnAssertFailureEnabled";
static NSString *OBEnableExpensiveAssertionsKey = @"OBEnableExpensiveAssertions";

static void OBDefaultAssertionHandler(const char *type, const char *expression, const char *file, unsigned int lineNumber)
{
    OBLogAssertionFailure(type, expression, file, lineNumber);

    if ([[NSUserDefaults standardUserDefaults] boolForKey:OBShouldAbortOnAssertFailureEnabled]) {
        // If we are running unit tests, abort on assertion failure.  We could make assertions throw exceptions, but note that this wouldn't catch cases where you are using 'shouldRaise' and hit an assertion.
#ifdef DEBUG
        // If we're failing in a debug build, give the developer a little time to connect in gdb before crashing
        fprintf(stderr, "You have 15 seconds to attach to pid %u in gdb...\n", getpid());
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:15.0]];
#endif
        abort();
    }
}

static OBAssertionFailureHandler currentAssertionHandler = OBDefaultAssertionHandler;
void OBSetAssertionFailureHandler(OBAssertionFailureHandler handler)
{
    if (handler)
        currentAssertionHandler = handler;
    else
        currentAssertionHandler = OBDefaultAssertionHandler;
}

void OBInvokeAssertionFailureHandler(const char *type, const char *expression, const char *file, unsigned int lineNumber)
{
    OBRecordBacktrace(0, OBBacktraceBuffer_OBAssertionFailure);
    currentAssertionHandler(type, expression, file, lineNumber);
    OBAssertFailed();
}

void OBAssertFailed(void)
{
    // For breakpoints
}

void _OBAssertNotImplemented(id self, SEL sel)
{
    if ([self respondsToSelector:sel]) {
        Class impClass = OBClassImplementingMethod([self class], sel);
        NSLog(@"%@ has implementation of %@", NSStringFromClass(impClass), NSStringFromSelector(sel));
        OBAssertFailed();
    }
}

#endif

#if defined(OMNI_ASSERTIONS_ON) || defined(DEBUG)

static void _OBAssertionLoad(void) __attribute__((constructor));
static void _OBAssertionLoad(void)
{
#ifdef OMNI_ASSERTIONS_ON
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *assertionDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithBool:OBIsRunningUnitTests()], OBShouldAbortOnAssertFailureEnabled,
                                       [NSNumber numberWithBool:NO], OBEnableExpensiveAssertionsKey,
                                       nil];
    [defaults registerDefaults:assertionDefaults];
    OBEnableExpensiveAssertions = [defaults boolForKey:OBEnableExpensiveAssertionsKey];
    if (getenv("OBASSERT_NO_BANNER") == NULL) {
        fprintf(stderr, "*** Assertions are ON ***\n");
        for(NSString *key in assertionDefaults) {
            fprintf(stderr, "    %s = %s\n",
                    [key cStringUsingEncoding:NSUTF8StringEncoding],
                    [defaults boolForKey:key]? "YES" : "NO");
        }
    }
    [pool release];
#elif DEBUG
    if (getenv("OBASSERT_NO_BANNER") == NULL)
        fprintf(stderr, "*** Assertions are OFF ***\n");
#endif
}
#endif
