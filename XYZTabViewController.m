//
//  XYZTabViewController.m
//  InLogger
//
//  Created by Joel Viklund on 25/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZTabViewController.h"
#import "AppDelegate.h"

@interface XYZTabViewController ()

@end

@implementation XYZTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    
    //add self to appDelegate
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app addController:self];
}

@end
