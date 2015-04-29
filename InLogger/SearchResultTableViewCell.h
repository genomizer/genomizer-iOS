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
@property (nonatomic, retain) IBOutlet UITextView *textView;
//@property SearchResultTableViewController *controller;

- (CGSize)textFieldSize;

@end
