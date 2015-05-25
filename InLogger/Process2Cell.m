//
//  Process2Cell.m
//  Genomizer
//
//  Created by Erik Berggren on 25/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import "Process2Cell.h"

@implementation Process2Cell
@synthesize inFileLabel, outFileLabel, paramTextField;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    // Initialization code
    paramTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"New params: %@", textField.text);
    if([self.delegate respondsToSelector:@selector(processCell2:didChangeParams:)]){
        [self.delegate processCell2:self didChangeParams:textField.text];
    }
}
@end
