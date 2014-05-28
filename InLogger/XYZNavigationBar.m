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
    if([XYZSegueController isPerformingSegue]) {
        return nil;
    } else {
        [XYZSegueController segueStarted];
        return [super popNavigationItemAnimated:animated];
    }
}

@end
