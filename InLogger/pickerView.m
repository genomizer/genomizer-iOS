//
//  pickerView.m
//  InLogger
//
//  Created by Linus Öberg on 06/05/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import "pickerView.h"
#import "XYZSearchTableViewCell.h"

@implementation pickerView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataPicker.count;
}

-(NSArray *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataPicker objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView1 didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    NSInteger selectedRow = [pickerView1 selectedRowInComponent:0];
    NSString *selectedPickerRow=[self.dataPicker objectAtIndex:selectedRow];
        for (XYZSearchTableViewCell *cell in _tableCells) {
            if([[_annotationsDict allKeys][pickerView1.tag] isEqual:cell.annotation]){
                cell.inputField.text = selectedPickerRow;
                cell.switchButton.on = true;
                cell.switchButton.enabled = true;
                [cell.inputField resignFirstResponder];
                _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
          
        }
  }
@end
