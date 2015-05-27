//
//  Process2Cell.m
//  Genomizer
//
//  Created by Erik Berggren on 25/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import "Process2Cell.h"

@implementation Process2Cell
@synthesize paramTextField, outFileTextField, outfile_ext, windowSizeTextField, minSmoothTextField, stepSizeTextField, meanOrMedianTextField;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    // Initialization code
    paramTextField.delegate         = self;
    outFileTextField.delegate       = self;
    windowSizeTextField.delegate    = self;
    minSmoothTextField.delegate     = self;
    stepSizeTextField.delegate      = self;
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
    if([textField isEqual:outFileTextField]){
        textField.text = [NSString stringWithFormat:@"%@.%@",textField.text, outfile_ext];
        if([self.delegate respondsToSelector:@selector(processCell2:didChangeOutFileName:)]){
            [self.delegate processCell2:self didChangeOutFileName:textField.text];
        }
        return;
    }
    NSString *key = nil;
    NSString *value = textField.text;
    if([textField isEqual:paramTextField]){
        key = @"params";
    } else if([textField isEqual:windowSizeTextField]){
        key = @"windowSize";
    } else if([textField isEqual:minSmoothTextField]){
        key = @"minSmooth";
    } else if([textField isEqual:stepSizeTextField]){
        key = @"stepsize";
    } else if([textField isEqual:meanOrMedianTextField]){
        key = @"meanOrMedian";
        value = value.lowercaseString;
    }
    
    if([self.delegate respondsToSelector:@selector(processCell2:didChangeValue:forKey:)]){
        [self.delegate processCell2:self didChangeValue:value forKey:key];
    }

}
@end
