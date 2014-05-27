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

- (void) viewDidAppear:(BOOL)animated
{
    UINavigationController *navController = [super navigationController];
    if ([navController isKindOfClass:[XYZNavigationController class]]) {
        [XYZNavigationController setBusy:NO];
    }
    [super viewDidAppear:animated];
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"should perform1");
    return ![XYZNavigationController isBusy];
}

- (void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"perform segueue2");
    if ([self shouldPerformSegueWithIdentifier:identifier sender:sender]) {
        [super performSegueWithIdentifier:identifier sender:sender];
    }
}

@end
