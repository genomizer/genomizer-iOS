//
//  XYZSearchResultTableViewCell.m
//  Genomizer
//
//  Class that represents a cell in the searchResultView tableView.
//

#import "XYZSearchResultTableViewCell.h"
#import "XYZSearchResultTableViewController.h"

@interface XYZSearchResultTableViewCell()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation XYZSearchResultTableViewCell

- (void)awakeFromNib
{
    self.textLabel.numberOfLines = 10;
}

- (void) setTextFieldText: (NSString *) text
{
    _textView.text = text;
}

- (IBAction)experimentTouchUpInside:(id)sender
{
    [_controller didSelectRow:_index];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _controller.selectedExperiment = _experiement;
    [super touchesBegan:touches withEvent:event];
}

- (CGSize)textFieldSize
{
    return self.textView.bounds.size;
}

@end
