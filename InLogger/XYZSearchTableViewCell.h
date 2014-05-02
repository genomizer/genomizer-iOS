//
//  XYZSearchTableViewCell.h
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZSearchViewController.h"

@interface XYZSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property NSString *annotation;
@property XYZSearchViewController *controller;


- (void)setButtonOn;

@end
