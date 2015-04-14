//
//  NavigationBar.m
//  Genomizer
//
//  The NavigationBar contains methods to automatically avoid
//  two segues to be executed at the same time.
//
//  All subclasses of this class must call the corresponding super methods
//  when overriding them.
//

#import "NavigationBar.h"
#import "SegueController.h"

@implementation NavigationBar

/**
 * Prevents a segue pop to be performed if another segue is animating.
 */
- (UINavigationItem *)popNavigationItemAnimated:(BOOL)animated
{
    if([SegueController isPerformingSegue]) {
        return nil;
    } else {
        [SegueController segueStarted];
        return [super popNavigationItemAnimated:animated];
    }
}

@end
