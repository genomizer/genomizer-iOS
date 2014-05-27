//
//  XYZSearchResultTableViewCell.m
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
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
