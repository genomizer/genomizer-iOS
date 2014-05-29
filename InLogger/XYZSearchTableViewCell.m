//
//  XYZSearchTableViewCell.m
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSearchTableViewCell.h"

@interface XYZSearchTableViewCell ()

@end

@implementation XYZSearchTableViewCell

- (IBAction)inputFieldValueChanged:(id)sender
{
    _switchButton.on = _inputField.text.length > 0;
    _annotation.selected = _switchButton.on;
}

- (IBAction)textFieldEditingDidEnd:(id)sender
{
    if(_inputField.text.length == 0) {
        _annotation.value = nil;
        _switchButton.on = NO;
        _annotation.selected = NO;
    } else {
        _annotation.value = _inputField.text;
    }
}

- (void) updateSwitchButton
{
    _switchButton.on = _inputField.text.length > 0;
    _annotation.selected = _switchButton.on;
}

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    if (sender.on) {
        if ([_inputField.text length] == 0) {
            [_inputField becomeFirstResponder];
        }
    } else {
        [_inputField resignFirstResponder];
    }
    _annotation.selected = sender.on;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_controller hideKeyboardAndAdjustTable];
    [super touchesBegan:touches withEvent:event];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_annotation.possibleValues count] + 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"";
    } else {
        return [_annotation.possibleValues objectAtIndex:row-1];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        _inputField.text = @"";
        _switchButton.on = NO;
    } else {
        _inputField.text = [_annotation.possibleValues objectAtIndex:row - 1];
        _switchButton.on = YES;
    }
    _annotation.selected = _switchButton.on;
}

- (IBAction)textFieldEditingDidBegin:(UITextField *)sender
{
    if (![_annotation isFreeText]) {
        _controller.pickerView.delegate = self;
        _controller.pickerView.dataSource = self;
        if (_annotation.value == nil || ![_annotation.possibleValues containsObject:_annotation.value]) {
            [_controller.pickerView selectRow:0 inComponent: 0 animated:NO];
        } else {
            [_controller.pickerView selectRow:[_annotation.possibleValues indexOfObject: _annotation.value] + 1 inComponent: 0 animated:NO];
        }
    } else {
        _controller.pickerView.delegate = nil;
        _controller.pickerView.dataSource = nil;
    }
    [_controller scrollToCell:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_controller hideKeyboardAndAdjustTable];
    return NO;
}

@end
