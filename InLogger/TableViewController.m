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
#import "TabBar2Controller.h"
#import "NavController.h"

@interface TableViewController ()

@end

@implementation TableViewController
@synthesize tabBar2Controller;

/**
 * Marks the segue as done.
 */
- (void) viewDidAppear:(BOOL)animated
{
    //[SegueController segueDone];
    [super viewDidAppear:animated];
}


-(TabBar2Controller *)getTabbar{
    NavController *nc = (NavController *)self.navigationController;
    return nc.tabBar2Controller;
}


/**
 * Marks the segue as started.
 */
- (void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{

        [super performSegueWithIdentifier:identifier sender:sender];
    
}

@end
