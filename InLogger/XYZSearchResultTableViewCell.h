//
//  XYZSearchResultTableViewCell.h
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZExperiment.h"
#import "XYZSearchResultTableViewController.h"

@interface XYZSearchResultTableViewCell : UITableViewCell

@property NSInteger index;

@property XYZExperiment *experiement;
@property XYZSearchResultTableViewController *controller;

- (void) setTextFieldText: (NSString *) text;
- (CGSize)textFieldSize;

@end
