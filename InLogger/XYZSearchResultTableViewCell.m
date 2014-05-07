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
   // [//self.text]
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTextFieldText: (NSString *) text
{
    _textView.text = text;
}

- (IBAction)experimentTouchDownInside:(id)sender
{
    _controller.selectedExperiment = _experiement;
    NSLog(@"ASD: %d", [_experiement numberOfFiles]);
}

- (CGSize)textFieldSize
{
    return self.textView.bounds.size;
}

@end
