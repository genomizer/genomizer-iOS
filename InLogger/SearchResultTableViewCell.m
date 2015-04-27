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



//#warning lol?
//- (IBAction)experimentTouchUpInside:(id)sender
//{
//    [_controller didSelectRow:_index];
//}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    _controller.selectedExperiment = _experiement;
//    [super touchesBegan:touches withEvent:event];
//}

- (CGSize)textFieldSize
{
    return self.textView.bounds.size;
}

@end
