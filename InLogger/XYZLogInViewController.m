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

@interface XYZLogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation XYZLogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _userField.delegate = self;
    _passwordField.delegate = self;
}

- (void) tryToLogIn
{
    NSString *username = _userField.text;
    NSString *password = _passwordField.text;
    NSError *error;
    if(username.length > 0 && password.length > 0) {
        [ServerConnection login:username withPassword:password error:&error];
        if (error) {
            [XYZPopupGenerator showErrorMessage:error];
        } else {
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    } else{
        [XYZPopupGenerator showPopupWithMessage:@"Please enter username and password."];
    }
}

- (IBAction)signInButtonTouchDown:(id)sender
{
    [self tryToLogIn];
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

@end
