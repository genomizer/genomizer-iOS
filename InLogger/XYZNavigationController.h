//
//  XYZNavigationController.h
//  Genomizer
//
//  Created by Joel Viklund on 26/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZNavigationController : UINavigationController

+ (BOOL) isBusy;
+ (void) setBusy: (BOOL) busy;

@end
