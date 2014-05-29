//
//  XYZNavigationBar.m
//  Genomizer
//
//  The XYZNavigationBar contains methods to automatically avoid
//  two segues to be executed at the same time.
//
//  All subclasses of this class must call the corresponding super methods
//  when overriding them.
//

#import "XYZNavigationBar.h"
#import "XYZSegueController.h"

@implementation XYZNavigationBar

/**
 * Prevents a segue pop to be performed if another segue is animating.
 */
- (UINavigationItem *)popNavigationItemAnimated:(BOOL)animated
{
    if([XYZSegueController isPerformingSegue]) {
        return nil;
    } else {
        [XYZSegueController segueStarted];
        return [super popNavigationItemAnimated:animated];
    }
}

@end
