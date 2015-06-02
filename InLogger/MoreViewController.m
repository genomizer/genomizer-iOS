//
//  MoreViewController.m
//  Genomizer
//
// Class that as of now only contains a logout-button.
//

#import "MoreViewController.h"
#import "ServerConnection.h"
#import "AppDelegate.h"
#import "JSONBuilder.h"
@interface MoreViewController ()

@end

@implementation MoreViewController
@synthesize serverLabel, userLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *serverURL = [JSONBuilder getServerURL];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    self.serverLabel.text = serverURL;
    self.userLabel.text = username;
}
/**
 * Method that executes when the "logout"-button is pressed.
 * Calls the method "logout" in serverConnection.
    @param sender Button which execute the method
 * @return kills all controllers and returns to logout screen.
 */
- (IBAction)logoutButtonTouched:(id)sender {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.userIsLoggingOut = YES;
    [app restart];
    [app resetUserToken];
    [ServerConnection logout:^{
        
    }];
    LogInViewController *viewController = (LogInViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self.tabBar2Controller presentViewController:viewController animated:false completion:nil];
}

@end