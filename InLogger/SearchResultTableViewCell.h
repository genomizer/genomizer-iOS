//
//  SearchResultTableViewCell.h
//  Genomizer
//
//  Class that represents a cell in the searchResultView tableView.
//

#import <UIKit/UIKit.h>
#import "Experiment.h"
#import "SearchResultTableViewController.h"

@interface SearchResultTableViewCell : UITableViewCell

@property NSInteger index;

@property Experiment *experiement;
@property SearchResultTableViewController *controller;

- (void) setTextFieldText: (NSString *) text;
- (CGSize)textFieldSize;

@end
