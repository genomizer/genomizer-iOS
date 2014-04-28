//
//  XYZLogInViewController.m
//  InLogger
//
//  Created by Joel Viklund on 24/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZLogInViewController.h"
#import "XYZInLogger.h"

@interface XYZLogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end



@implementation XYZLogInViewController

- (void)validate {
    if ([XYZInLogger validAccount:self.userField.text withPassword:self.passwordField.text]) {
        //XYZHomeViewController *viewController = [[XYZHomeViewController alloc] init];
        //[self presentViewController:asdasd animated:YES completion:nil];
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    } else {
        [self showMessage];
    }
}

- (IBAction)SignInButtonTouchDOwn:(id)sender {
    [self validate];
}

- (IBAction)showMessage
{
    UIAlertView *helloWorldAlert = [[UIAlertView alloc]
                                    initWithTitle:@"" message:@"Wrong username or password." delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
    
    // Display the Hello World Message
    [helloWorldAlert show];
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
    //NSLog(@"%f %f", self.view.frame.origin.y, self.view.center.y);
    if(self.view.frame.origin.y < 0) {
        return;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height);
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
    // Do any additional setup after loading the view from its nib.

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
        [self validate];
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
