//
//  XYZSelectedFilesViewController.h
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZExperiment.h"


@interface XYZSelectedFilesViewController : UIViewController 

+ (void)addExperimentFile:(XYZExperimentFile *) file;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
