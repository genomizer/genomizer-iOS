//
//  XYZSearchResultTableViewController.h
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZExperiment.h"

@interface XYZSearchResultTableViewController : UITableViewController

@property XYZExperiment * selectedExperiment;

- (NSMutableArray *) createSearchFields;

@end
