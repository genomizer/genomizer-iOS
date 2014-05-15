//
//  XYZSearchTableViewCell.m
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSearchTableViewCell.h"

@interface XYZSearchTableViewCell ()

@property UIPickerView *pickerView;

@end

@implementation XYZSearchTableViewCell

- (IBAction)inputFieldValueChanged:(id)sender
{
    [self updateSwitchButton];
}

- (IBAction)textFieldEditingDidEnd:(id)sender
{
    _annotation.value = _inputField.text;
    [self updateSwitchButton];
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

- (UIPickerView *) createPickerView
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 44, 44)];
    
    pickerView.delegate = self;
    pickerView.backgroundColor = [UIColor colorWithRed:247.0/255.0f green:248.0/255.0f
                                                  blue:247.0/255 alpha:1.0f];
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    return pickerView;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_annotation.possibleValues count];
}

-(NSArray *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_annotation.possibleValues objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    NSString *selectedValue = [_annotation.possibleValues objectAtIndex:row];
    _inputField.text = selectedValue;
    _switchButton.on = [selectedValue length] > 0;
}

- (IBAction)textFieldEditingDidBegin:(UITextField *)sender
{
    if (![_annotation isFreeText]) {
        if (_pickerView == nil) {
            _pickerView = [self createPickerView];
            _inputField.inputView = _pickerView;
        }
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _pickerView.bounds.size.width, 44)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
        [toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
        _inputField.inputAccessoryView = toolBar;
    }
    
    [_controller scrollToCell:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_controller hideKeyboardAndAdjustTable];
    return NO;
}

-(void)doneTouched:(UIBarButtonItem*)sender
{
    [_controller hideKeyboardAndAdjustTable];
}

@end
