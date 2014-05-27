//
//  XYZNavigationController.m
//  Genomizer
//
//  Created by Joel Viklund on 26/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZNavigationController.h"

@interface XYZNavigationController ()

@end

@implementation XYZNavigationController

static BOOL BUSY;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    NSLog(@"popping");
    if ([XYZNavigationController isBusy]) {
        return nil; //[super topViewController];
    } else {
        [XYZNavigationController setBusy:YES];
        return [super popViewControllerAnimated:animated];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![XYZNavigationController isBusy]) {
        [XYZNavigationController setBusy:YES];
        [super pushViewController:viewController animated:animated];
    }
}

+ (BOOL) isBusy
{
    return BUSY;
}

+ (void) setBusy: (BOOL) busy
{
    BUSY = busy;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
