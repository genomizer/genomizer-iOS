//
//  LogInViewController.m
//  Genomizer
//
//  Class that handles the loginScreen
//

#import "LogInViewController.h"
#import "ServerConnection.h"
#import "PopupGenerator.h"
#import "AppDelegate.h"
#import "SettingsPopupDelegate.h"
#import "JSONBuilder.h"
#import "FileHandler.h"
#import "Reachability.h"

@interface LogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property SettingsPopupDelegate *delegate;
@end

@implementation LogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _userField.delegate = self;
    _passwordField.delegate = self;
    _spinner.hidden = YES;
    _spinner.hidesWhenStopped = YES;
    _delegate = [[SettingsPopupDelegate alloc] init];
    
    NSString *serverURL = [FileHandler readFromFile: SERVER_URL_FILE_NAME withDefaultData:MOCK_URL];
    [JSONBuilder setServerURLToString:serverURL];
    
    //add self to appDelegate
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    [app addController:self];
}

/**
 * Method that checks if any internetconnection is aviable if thats the case
 * a call to the serverConnection method "login" is called.
 * @return calls login-method in serverConnection.
 */
- (void) tryToLogIn
{
    NSString *username = _userField.text;
    NSString *password = _passwordField.text;
    NSError *error;
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [PopupGenerator showPopupWithMessage:@"There is no internet connection." withTitle:@"Connection Error"];
        
    } else {
        
        if((username.length > 0) && (password.length > 0))
        {
            [ServerConnection login:self.userField.text withPassword:self.passwordField.text error:&error withContext:self];
            [_spinner startAnimating];
            [self deactivateEverything];
            
        } else{
            [PopupGenerator showPopupWithMessage:@"Please enter username and password."];
        }
    }
    
}
/*
 * Method that deactivates every user interaction enabled object, executes when
 * the "signIn"-button is pressed.
 */
- (void) deactivateEverything
{
    _loginButton.enabled = NO;
    _loginButton.hidden = YES;
    _userField.enabled = NO;
    _passwordField.enabled = NO;
    _settingsButton.enabled = NO;
}

/*
 * Method that activates every user interaction enabled object, executes when
 * the "signIn" sequence is done.
 */
- (void) activateEverything
{
    _loginButton.enabled = YES;
    _loginButton.hidden = NO;
    _userField.enabled = YES;
    _passwordField.enabled = YES;
    _settingsButton.enabled = YES;
}

/**
 * Executes when the "signIn"-button is pressed.
 */
- (IBAction)signInButtonTouchUp:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self centerFrameView];
    [self tryToLogIn];
}
/**
 * Method that is called by serverConnection when a login reqest is sent to the server
 * and a response is recived.
 * @param error - Contains information about error is such have occured.
 * @return if a error occured a popup with information about the error is shown.
 *         else a segue to the searchView is preformed.
 */
- (void) reportLoginResult: (NSError*) error {
    
    if(error == nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            app.userIsLoggingOut = NO;
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        });
    } else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_spinner stopAnimating];
            [self activateEverything];
            [PopupGenerator showErrorMessage:error];
        });
    }
}
/**
 * Executes when a textfield is clicked.
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.view.frame.origin.y < 0) {
        return;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    // Move frame so that keyboard is not on top of any inputfield.
    self.view.frame = CGRectMake(0, -140, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

/**
 * Puts frame back to its original center.
 */
- (void)centerFrameView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self centerFrameView];
    [super touchesBegan:touches withEvent:event];
}

/**
 * Describes what is shoud happen if the "next" button on the keyboard is pressed.
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _userField) {
        [_passwordField becomeFirstResponder];
    } else if(textField == _passwordField) {
        [_passwordField resignFirstResponder];
        [self centerFrameView];
        [self tryToLogIn];
    }
    return NO;
}

/**
 * Executes when the settings-icon in top-right corner is pressed.
 * Shows a popup with a textfield where the user can input the URL to the server.
 */
- (IBAction)settingsButtonPressed:(id)sender
{
    [PopupGenerator showInputPopupWithMessage:@"Enter server URL:" withTitle:@"" withText: [JSONBuilder getServerURL] withDelegate:_delegate];
}


@end