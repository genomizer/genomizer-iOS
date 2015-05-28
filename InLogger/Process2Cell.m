//
//  Process2Cell.m
//  Genomizer
//
//  Created by Erik Berggren on 25/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import "Process2Cell.h"

@implementation Process2Cell
@synthesize paramTextField, outFileTextField, outfile_ext, windowSizeTextField, minSmoothTextField, stepSizeTextField, meanOrMedianTextField, readsCutOffTextField, chromosomeTextField, outFilePostTextField, switchButton;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    // Initialization code
    paramTextField.delegate         = self;
    outFileTextField.delegate       = self;
    windowSizeTextField.delegate    = self;
    minSmoothTextField.delegate     = self;
    stepSizeTextField.delegate      = self;
    chromosomeTextField.delegate    = self;
    readsCutOffTextField.delegate   = self;
    meanOrMedianTextField.delegate  = self;
    outFilePostTextField.delegate   = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if([textField isEqual:outFileTextField] || [textField isEqual:outFilePostTextField]){
        textField.text = [textField.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", outfile_ext] withString:@""];
    }
    if([self.delegate respondsToSelector:@selector(processCell2:didBeginEdit:)]){
        [self.delegate processCell2:self didBeginEdit:textField];
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
    } else if([textField isEqual:readsCutOffTextField]){
        key = @"readsCutoff";
    } else if([textField isEqual:chromosomeTextField]){
        key = @"chromosome";
    } else if([textField isEqual:outFilePostTextField]){
        key = @"infile_post";
        textField.text = [NSString stringWithFormat:@"%@.%@",textField.text, outfile_ext];
        value = textField.text;
    }
    
    if([self.delegate respondsToSelector:@selector(processCell2:didChangeValue:forKey:)]){
        [self.delegate processCell2:self didChangeValue:value forKey:key];
    }
    if([self.delegate respondsToSelector:@selector(processCell2:didEndEdit:)]){
        [self.delegate processCell2:self didEndEdit:textField];
    }

}

-(IBAction)ratioSwitchPrePost:(id)sender{
    NSString *newPost = outFileTextField.text;
    NSString *newPre = outFilePostTextField.text;
    if([self.delegate respondsToSelector:@selector(processCell2:didChangeValue:forKey:forceReload:)]){
        [self.delegate processCell2:self didChangeOutFileName:newPre];
        [self.delegate processCell2:self didChangeValue:newPost forKey:@"infile_post" forceReload:true];
        
    }
}
@end
