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

@property NSUInteger prevSelectedIndex;

@end

@implementation XYZTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    _prevSelectedIndex = 0;
    
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
    if ([XYZSegueController isPerformingSegue]) {
        return false;
    } else if(viewController != tabBarController.selectedViewController) {
        return true;
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)viewController).viewControllers.count > 1;
    } else {
        return true;
    }
}

@end
