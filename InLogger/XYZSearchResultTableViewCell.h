//
//  XYZSearchResultTableViewCell.h
//  Genomizer
//
//  Class that represents a cell in the searchResultView tableView.
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
