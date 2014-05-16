//
//  XYZDataFileTableViewCell.h
//  InLogger
//
//  Created by Joel Viklund on 15/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZExperimentFile.h"
#import "XYZDataFileViewController.h"

@interface XYZDataFileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *textField;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@property XYZExperimentFile *file;
@property XYZDataFileViewController* controller;

@end
