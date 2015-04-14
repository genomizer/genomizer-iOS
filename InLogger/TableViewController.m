//
//  TableViewController.m
//  Genomizer
//
//  The TableViewController contains methods to automatically avoid
//  two segues to be executed at the same time.
//
//  All subclasses of this class must call the corresponding super methods
//  when overriding them.
//

#import "TableViewController.h"
#import "SegueController.h"

@interface TableViewController ()

@end

@implementation TableViewController

/**
 * Marks the segue as done.
 */
- (void) viewDidAppear:(BOOL)animated
{
    [SegueController segueDone];
    [super viewDidAppear:animated];
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
