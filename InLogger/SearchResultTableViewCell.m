//
//  SearchResultTableViewCell.m
//  Genomizer
//
//  Class that represents a cell in the searchResultView tableView.
//

#import "SearchResultTableViewCell.h"
#import "SearchResultTableViewController.h"

@interface SearchResultTableViewCell()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SearchResultTableViewCell

- (void)awakeFromNib
{
    self.textLabel.numberOfLines = 10;
}

- (void) setTextFieldText: (NSString *) text
{
    _textView.text = text;
}

- (CGSize)textFieldSize
{
    return self.textView.bounds.size;
}

@end
