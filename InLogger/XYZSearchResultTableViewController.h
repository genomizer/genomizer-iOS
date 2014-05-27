//
//  XYZSearchResultTableViewController.h
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZExperiment.h"
#import "XYZExperimentDescriber.h"
#import "XYZTableViewController.h"

@interface XYZSearchResultTableViewController : XYZTableViewController

@property XYZExperimentDescriber *experimentDescriber;
@property XYZExperiment * selectedExperiment;
@property XYZExperiment *selectedFiles;
@property NSArray *searchResults;

-(void) didSelectRow: (NSInteger) row;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
