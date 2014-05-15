//
//  XYZSearchTableViewCell.h
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZSearchViewController.h"
#import "XYZAnnotation.h"

@interface XYZSearchTableViewCell : UITableViewCell<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property XYZSearchViewController *controller;
@property XYZAnnotation *annotation;

@end
