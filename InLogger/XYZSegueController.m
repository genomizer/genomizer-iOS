//
//  XYZSegueController.m
//  Genomizer
//
//  The XYZSeguwController controlls the segues to automatically avoid
//  two segues to be executed at the same time. It contains static methods
//  to keep track of if a segue is animating.
//

#import "XYZSegueController.h"

@implementation XYZSegueController

static BOOL BUSY;

/**
 * Returns YES if a segue is being performed and NO otherwise.
 *
 * @return YES if a segue is being performed and NO otherwise.
 */
+ (BOOL) isPerformingSegue
{
    return BUSY;
}

/**
 * Called when a segue is done animating. Allows other segues the be performed.
 */
+ (void) segueDone
{
    BUSY = NO;
}

/**
 * Called when a seuge starts animating. Blocks all other segues.
 */
+ (void) segueStarted
{
    BUSY = YES;
}

@end
