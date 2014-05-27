//
//  XYZSearchViewController.h
//  InLogger
//
//  Created by Joel Viklund on 25/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZViewController.h"
#import "XYZExperimentDescriber.h"

@interface XYZSearchViewController : XYZViewController<UITextFieldDelegate>

@property UIPickerView *pickerView;
@property UIToolbar *toolBar;
@property NSArray *annotations;

- (void) hideKeyboardAndAdjustTable;
- (void) scrollToCell: (UITableViewCell *) cell;
- (void) reportSearchResult: (NSMutableArray*) result error: (NSError*) error;
- (void) reportAnnotationResult: (NSArray*) result error: (NSError*) error;

@end
