//
//  XYZViewController.m
//  Genomizer
//
//  Created by Joel Viklund on 26/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZViewController.h"
#import "XYZNavigationController.h"

@interface XYZViewController ()

@end

@implementation XYZViewController

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"shoudld peroreo");
    return YES;
    //return ![XYZNavigationController isBusy];
}

- (void) viewDidAppear:(BOOL)animated
{
    UINavigationController *navController = [super navigationController];
    if ([navController isKindOfClass:[XYZNavigationController class]]) {
        [XYZNavigationController setBusy:NO];
    }
    [super viewDidAppear:animated];
    
}

@end
