//
//  XYZViewController.m
//  Genomizer
//
//  Created by Joel Viklund on 26/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZViewController.h"
#import "XYZSegueController.h"

@interface XYZViewController ()

@end

@implementation XYZViewController

- (void) viewDidAppear:(BOOL)animated
{
    [XYZSegueController segueDone];
    [super viewDidAppear:animated];
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return ![XYZSegueController isPerformingSegue];
}

- (void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([self shouldPerformSegueWithIdentifier:identifier sender:sender]) {
        [XYZSegueController segueStarted];
        [super performSegueWithIdentifier:identifier sender:sender];
    }
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
   // NSLog(@"SDASDAS");
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
