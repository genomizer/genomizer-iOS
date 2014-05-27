//
//  XYZSegueController.h
//  Genomizer
//
//  Created by Joel Viklund on 27/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZSegueController : NSObject

+ (BOOL) isPerformingSegue;
+ (void) segueDone;
+ (void) segueStarted;

@end
