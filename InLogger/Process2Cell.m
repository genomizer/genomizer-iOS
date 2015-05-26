//
//  Process2Cell.m
//  Genomizer
//
//  Created by Erik Berggren on 25/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import "Process2Cell.h"

@implementation Process2Cell
@synthesize inFileLabel, outFileLabel, paramTextField, outFileTextField, outfile_ext;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    // Initialization code
    paramTextField.delegate     = self;
    outFileTextField.delegate   = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if([textField isEqual:outFileTextField]){
        textField.text = [textField.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", outfile_ext] withString:@""];
    }
    if([self.delegate respondsToSelector:@selector(processCell2DidBeginEdit:)]){
        [self.delegate processCell2DidBeginEdit:textField];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"New params: %@", textField.text);
    if([textField isEqual:paramTextField]){
        if([self.delegate respondsToSelector:@selector(processCell2:didChangeParams:)]){
            [self.delegate processCell2:self didChangeParams:textField.text];
        }
    } else if([textField isEqual:outFileTextField]){
        textField.text = [NSString stringWithFormat:@"%@.%@",textField.text, outfile_ext];
        if([self.delegate respondsToSelector:@selector(processCell2:didChangeOutFileName:)]){
            [self.delegate processCell2:self didChangeOutFileName:textField.text];
        }
    }

}
@end
