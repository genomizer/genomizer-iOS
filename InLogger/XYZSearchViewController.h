//
//  XYZSearchViewController.h
//  InLogger
//
//  Created by Joel Viklund on 25/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZExperimentDescriber.h";

@interface XYZSearchViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate>

@property XYZExperimentDescriber *experimentDescriber;

- (void)hideKeyboardAndAdjustTable;
- (void) setDataInCells:(NSString *)data taggen:(NSInteger)tagg;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
@end
