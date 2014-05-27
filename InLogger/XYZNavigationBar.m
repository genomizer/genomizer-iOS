//
//  XYZNavigationBar.m
//  Genomizer
//
//  Created by Joel Viklund on 26/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZNavigationBar.h"
#import "XYZNavigationController.h"

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
    if([XYZNavigationController isBusy]) {
        return nil;
    } else {
        return [super popNavigationItemAnimated:animated];
    }
}

@end
