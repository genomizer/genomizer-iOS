//
//  XYZDataFileViewController.h
//  InLogger
//
//  Created by Joel Viklund on 30/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZExperiment.h"

@interface XYZDataFileViewController : UIViewController

- (IBAction) unwindToList:(UIStoryboardSegue *)segue;

@property (nonatomic) XYZExperiment *experiment;

@end
