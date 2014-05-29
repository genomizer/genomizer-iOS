//
//  XYZViewController.m
//  Genomizer
//
//  The XYZViewController contains methods to automatically avoid
//  two segues to be executed at the same time.
//
//  All subclasses of this class must call the corresponding super methods
//  when overriding them.
//

#import "XYZViewController.h"
#import "XYZSegueController.h"

@interface XYZViewController ()

@end

@implementation XYZViewController

/**
 * Marks the segue as done.
 */
- (void) viewDidAppear:(BOOL)animated
{
    [XYZSegueController segueDone];
    [super viewDidAppear:animated];
}

/**
 * Checks if the segue should be performed.
 */
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return ![XYZSegueController isPerformingSegue];
}

/**
 * Marks the segue as started.
 */
- (void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([self shouldPerformSegueWithIdentifier:identifier sender:sender]) {
        [XYZSegueController segueStarted];
        [super performSegueWithIdentifier:identifier sender:sender];
    }
}

@end
