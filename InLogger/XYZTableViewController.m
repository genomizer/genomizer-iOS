//
//  XYZTableViewController.m
//  Genomizer
//
//  Created by Joel Viklund on 26/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZTableViewController.h"
#import "XYZSegueController.h"

@interface XYZTableViewController ()

@end

@implementation XYZTableViewController

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"table view controller did appear");
    [XYZSegueController segueDone];
    [super viewDidAppear:animated];
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"should perform3");
    return ![XYZSegueController isPerformingSegue];
}

- (void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"perform segueue4");
    if ([self shouldPerformSegueWithIdentifier:identifier sender:sender]) {
        [XYZSegueController segueStarted];
        [super performSegueWithIdentifier:identifier sender:sender];
    }
}

@end
