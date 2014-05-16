//
//  XYZSearchViewController.h
//  InLogger
//
//  Created by Joel Viklund on 25/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZExperimentDescriber.h"

@interface XYZSearchViewController : UIViewController<UITextFieldDelegate>

@property NSArray *annotations;

- (void) hideKeyboardAndAdjustTable;
- (void) scrollToCell: (UITableViewCell *) cell;
- (void) reportSearchResult: (NSMutableArray*) result withParsingError: (NSError*) error;
- (void) reportAnnotationResult: (NSArray*) result error: (NSError*) error;

@end
