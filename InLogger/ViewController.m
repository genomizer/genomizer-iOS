//
//  ViewController.m
//  Genomizer
//
//  The ViewController contains methods to automatically avoid
//  two segues to be executed at the same time.
//
//  All subclasses of this class must call the corresponding super methods
//  when overriding them.
//

#import "ViewController.h"
#import "SegueController.h"
#import "NavController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize tabBar2Controller;
/**
 * Marks the segue as done.
 */
- (void) viewDidAppear:(BOOL)animated
{
    [SegueController segueDone];
    [super viewDidAppear:animated];
}

-(TabBar2Controller *)getTabbar{
    NavController *nc = (NavController *)self.navigationController;
    NSLog(@"tabbar 15: %@", nc.tabBar2Controller);
    return nc.tabBar2Controller;
}

/**
 * Checks if the segue should be performed.
 */
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return ![SegueController isPerformingSegue];
}

/**
 * Marks the segue as started.
 */
- (void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([self shouldPerformSegueWithIdentifier:identifier sender:sender]) {
        [SegueController segueStarted];
        [super performSegueWithIdentifier:identifier sender:sender];
    }
}

@end
