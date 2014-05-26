//
//  XYZLogInViewController.m
//  InLogger
//
//  Created by Joel Viklund on 24/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZLogInViewController.h"
#import "ServerConnection.h"
#import "XYZPopupGenerator.h"
#import "AppDelegate.h"
#import "XYZSettingsPopupDelegate.h"
#import "JSONBuilder.h"
#import "XYZFileHandler.h"

@interface XYZLogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property XYZSettingsPopupDelegate *delegate;


@end

@implementation XYZLogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _userField.delegate = self;
    _passwordField.delegate = self;
    _spinner.hidden = YES;
    _spinner.hidesWhenStopped = YES;
    _delegate = [[XYZSettingsPopupDelegate alloc] init];
    
    [JSONBuilder setServerURLToString: [XYZFileHandler readFromFile: SERVER_URL_FILE_NAME withDefaultData:MOCK_URL]];
    
    //add self to appDelegate
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app addController:self];
}

- (void) tryToLogIn
{
    NSString *username = _userField.text;
    NSString *password = _passwordField.text;
    NSError *error;
    
    if((username.length > 0) && (password.length > 0))
    {
        [ServerConnection login:self.userField.text withPassword:self.passwordField.text error:&error withContext:self];
        [_spinner startAnimating];
        [self deactivateEverything];
        
    } else{
        [XYZPopupGenerator showPopupWithMessage:@"Please enter username and password."];
    }
}

- (void) deactivateEverything
{
    _loginButton.enabled = NO;
    _loginButton.hidden = YES;
    _userField.enabled = NO;
    _passwordField.enabled = NO;
    _settingsButton.enabled = NO;
}

- (void) activateEverything
{
    _loginButton.enabled = YES;
    _loginButton.hidden = NO;
    _userField.enabled = YES;
    _passwordField.enabled = YES;
    _settingsButton.enabled = YES;
}

- (IBAction)signInButtonTouchUp:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self centerFrameView];
    [self tryToLogIn];
}

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
            [XYZPopupGenerator showErrorMessage:error];
        });
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.view.frame.origin.y < 0) {
        return;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0, -140, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

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

- (IBAction)settingsButtonPressed:(id)sender
{
    [XYZPopupGenerator showInputPopupWithMessage:@"Enter server URL:" withTitle:@"" withText: [JSONBuilder getServerURL] withDelegate:_delegate];
}


@end
