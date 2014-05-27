//
//  XYZDataFileViewController.h
//  InLogger
//
//  Created by Joel Viklund on 30/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZExperiment.h"
#import "XYZViewController.h"

@interface XYZDataFileViewController : XYZViewController

@property (nonatomic) XYZExperiment *experiment;
@property XYZFileContainer *selectedFiles;

- (IBAction) unwindToList:(UIStoryboardSegue *)segue;
- (void) showInfoAbout: (XYZExperimentFile *) file;

@end
