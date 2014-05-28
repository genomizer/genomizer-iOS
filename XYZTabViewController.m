//
//  XYZTabViewController.m
//  InLogger
//
//  Created by Anonymous on 25/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSegueController.h"
#import "XYZTabViewController.h"
#import "AppDelegate.h"

@interface XYZTabViewController ()

@end

@implementation XYZTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    
    //add self to appDelegate
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app addController:self];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [XYZSegueController segueStarted];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return ![XYZSegueController isPerformingSegue];
}

@end
