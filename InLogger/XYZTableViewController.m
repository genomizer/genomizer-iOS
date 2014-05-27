//
//  XYZTableViewController.m
//  Genomizer
//
//  Created by Joel Viklund on 26/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZTableViewController.h"
#import "XYZNavigationController.h"

@interface XYZTableViewController ()

@end

@implementation XYZTableViewController

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"DID APPEAR");
    UINavigationController *navController = [super navigationController];
    if ([navController isKindOfClass:[XYZNavigationController class]]) {
        [XYZNavigationController setBusy:NO];
    }
    [super viewDidAppear:animated];
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"shoudld peroreo");
    return YES;
    //return ![XYZNavigationController isBusy];
}

@end
