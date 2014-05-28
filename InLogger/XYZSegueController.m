//
//  XYZSegueController.m
//  Genomizer
//
//  Created by Joel Viklund on 27/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSegueController.h"

@implementation XYZSegueController

static BOOL BUSY;

+ (BOOL) isPerformingSegue
{
    return BUSY;
}

+ (void) segueDone
{
    BUSY = NO;
}

+ (void) segueStarted
{
    BUSY = YES;
}

@end
