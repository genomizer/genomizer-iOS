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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.inputField resignFirstResponder];
    //[self.view endEditing:YES];
    //[self centerFrameView];
    //[super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.inputField resignFirstResponder];
    NSLog(@"ASDASD");

    /*
     if(textField == self.userField) {
     [self.passwordField becomeFirstResponder];
     } else if(textField == self.passwordField) {
     [self.passwordField resignFirstResponder];
     [self centerFrameView];
     [self validate];
     }*/
    return NO;
}


@end
