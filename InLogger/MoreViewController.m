//
//  MoreViewController.m
//  InLogger
//
//  Created by Linus Öberg on 30/04/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import "MoreViewController.h"
#import "ServerConnection.h"
@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)logoutButtonTouched:(id)sender {
    NSError * error;
    [ServerConnection logout:&error];
}

@end
