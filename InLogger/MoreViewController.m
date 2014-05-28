//
//  MoreViewController.m
//  InLogger
//
//  Created by Linus Öberg on 30/04/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
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

- (IBAction)logoutButtonTouched:(id)sender {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.userIsLoggingOut = YES;
    [ServerConnection logout];
    [app killControllers];
    [app restart];
}

@end