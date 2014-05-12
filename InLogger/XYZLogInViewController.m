//
//  XYZLogInViewController.m
//  InLogger
//
//  Created by Joel Viklund on 24/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZLogInViewController.h"
#import "ServerConnection.h"

@interface XYZLogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end



@implementation XYZLogInViewController

- (void)validateWithUser:(NSString*) login andPassword: (NSString*) password {
    NSError *error;
    
    if((login.length > 1) && (password.length > 3)) {
        [ServerConnection login:self.userField.text withPassword:self.passwordField.text error:&error];
   
        if (error) {
               [self showMessage:[error.userInfo objectForKey:NSLocalizedDescriptionKey]  title:error.domain];
            
        } else {
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    } else{
        [self showMessage:@"Username or password is too short." title:@"Error"];
    }
}

- (IBAction)SignInButtonTouchDOwn:(id)sender {
    [self validateWithUser: self.userField.text andPassword: self.passwordField.text];
}

- (IBAction)showMessage:(NSString*) error title:(NSString*)title;
{
    UIAlertView *loginFailed = [[UIAlertView alloc]
                                initWithTitle:title message:error
                                delegate:nil cancelButtonTitle:@"Try again"
                                otherButtonTitles:nil];
    
    [loginFailed show];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.userField.delegate = self;
    self.passwordField.delegate = self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self centerFrameView];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.userField) {
        [self.passwordField becomeFirstResponder];
    } else if(textField == self.passwordField) {
        [self.passwordField resignFirstResponder];
        [self centerFrameView];
        if((self.userField.text.length > 1) && (self.passwordField.text.length > 3)) {
            NSLog(@"boriz");
            [self validateWithUser: self.userField.text andPassword: self.passwordField.text];
        }
        else{
            [self showMessage:@"Username or password is too short." title:@"Error"];
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
