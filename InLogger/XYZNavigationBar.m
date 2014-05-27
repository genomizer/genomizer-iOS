//
//  XYZNavigationBar.m
//  Genomizer
//
//  Created by Joel Viklund on 26/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZNavigationBar.h"
#import "XYZSegueController.h"

@implementation XYZNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UINavigationItem *)popNavigationItemAnimated:(BOOL)animated
{
    NSLog(@"POPOPOP");
    if([XYZSegueController isPerformingSegue]) {
        NSLog(@"no popopop");
        return nil;
    } else {
        NSLog(@"yes popoppo");
        return [super popNavigationItemAnimated:animated];
    }
}

@end
