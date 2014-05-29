//
//  XYZTabViewController.m
//  Genomizer
//
//  The XYZTabViewController contains methods to automatically avoid
//  two segues to be executed at the same time.
//
//

#import "XYZSegueController.h"
#import "XYZTabViewController.h"
#import "AppDelegate.h"

@interface XYZTabViewController ()

@property NSUInteger prevSelectedIndex;

@end

@implementation XYZTabViewController

/**
 * Initial setup on view did load. Add self to appdelegate.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.navigationItem.hidesBackButton = YES;
    _prevSelectedIndex = 0;
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app addController:self];
}

/**
 * Marks the segue as started.
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [XYZSegueController segueStarted];
}

/**
 * Determines if a segue should be performed. Checks if a segue already is animating.
 *
 */
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([XYZSegueController isPerformingSegue]) {
        return false;
    } else if(viewController != tabBarController.selectedViewController) {
        return true;
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)viewController).viewControllers.count > 1;
    } else {
        return true;
    }
}

@end
