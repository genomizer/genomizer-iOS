//
//  XYZSearchTableViewCell.m
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSearchTableViewCell.h"

@implementation XYZSearchTableViewCell

- (void)awakeFromNib
{
    //self.inputField.delegate = self;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)inputFieldValueChanged:(id)sender {
    if(self.inputField.text.length == 0) {
        self.switchButton.on = false;
        self.switchButton.enabled = false;
    } else {
        self.switchButton.enabled = true;
        self.switchButton.on = true;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    
}

- (void)setButtonOn{
    self.switchButton.on = true;
}





@end
