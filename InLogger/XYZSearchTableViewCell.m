//
//  XYZSearchTableViewCell.m
//  Genomizer
//
// Class that represents a cell in the searchView tableView.
// Contains logic for which switchButton should be activated when
// and what should happen when textfields have begin/end-editing.
//

#import "XYZSearchTableViewCell.h"

@interface XYZSearchTableViewCell ()

@end

@implementation XYZSearchTableViewCell

/**
 * Executes when a user enter text into a textfield.
 * 
 * @return the corresponding switchbutton is activated.
 */
- (IBAction)inputFieldValueChanged:(id)sender
{
    _switchButton.on = _inputField.text.length > 0;
    _annotation.selected = _switchButton.on;
}
/**
 * Executes when all text is enterd into a textfield.
 */
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
/**
 * Executes when a switch button is pressed.
 */
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
    // returns number of sections i pickerview.
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // returns number of rows in pickerview.
    return [_annotation.possibleValues count] + 1;
}

/**
 * Method that fill a pickerview with data.
 */
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @""; // empty first row in pickerview.
    } else {
        return [_annotation.possibleValues objectAtIndex:row-1];
    }
}
/**
 * Method that executes when a item is selected in a pickerview.
 */
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
/**
 * Executes when a textfield have began editing.
 */
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
