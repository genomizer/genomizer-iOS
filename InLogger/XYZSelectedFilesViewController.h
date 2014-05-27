//
//  XYZSelectedFilesViewController.h
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZViewController.h"
#import "XYZExperiment.h"


@interface XYZSelectedFilesViewController : XYZViewController

+ (void) addExperimentFile:(XYZExperimentFile *) file;
+ (void) removeExperimentFile:(XYZExperimentFile *) file;
- (IBAction) unwindToList:(UIStoryboardSegue *)segue;

@end
