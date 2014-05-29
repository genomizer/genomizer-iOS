//
//  MoreViewController.m
//  Genomizer
//
// Class that as of now only contains a logout-button.
//

#import "MoreViewController.h"
#import "ServerConnection.h"
#import "AppDelegate.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //add self to appDelegate
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app addController:self];
}
/**
 * Method that executes when the "logout"-button is pressed.
 * Calls the method "logout" in serverConnection.
 * @return kills all controllers and returns to logout screen.
 */
- (IBAction)logoutButtonTouched:(id)sender {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.userIsLoggingOut = YES;
    NSError * error;
    [ServerConnection logout:&error];
    [app killControllers];
    [app restart];
}

@end