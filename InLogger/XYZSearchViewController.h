//
//  XYZSearchViewController.h
//  InLogger
//
//  Created by Joel Viklund on 25/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZExperimentDescriber.h"
#import "XYZSearchTableViewCell.h"

@interface XYZSearchViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate>


- (void)hideKeyboardAndAdjustTable;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void) createPickerViews;

@end
