//
//  SearchResultTableViewCell.m
//  Genomizer
//
//  Class that represents a cell in the searchResultView tableView.
//

#import "SearchResultTableViewCell.h"
#import "SearchResultTableViewController.h"

@interface SearchResultTableViewCell()

@end

@implementation SearchResultTableViewCell
@synthesize textView;
- (void)awakeFromNib
{
    self.textLabel.numberOfLines = 10;
}


- (CGSize)textFieldSize
{
    return self.textView.bounds.size;
}

@end
