//
//  pickerView.m
//  InLogger
//
//  Created by Linus Öberg on 06/05/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import "pickerView.h"
#import "XYZSearchViewController.h"
#import "XYZSearchTableViewCell.h"

@implementation pickerView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 
 */


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1; // For one column
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return self.dataPicker.count; // Numbers of rows
}

-(NSArray *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [self.dataPicker objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView1 didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    NSInteger selectedRow = [pickerView1 selectedRowInComponent:0];
    NSString *selectedPickerRow=[self.dataPicker objectAtIndex:selectedRow];
    
    if(pickerView1.tag==2){
        for (XYZSearchTableViewCell *cell in _tableCells) {
            if([cell.inputField.placeholder isEqual:@"Species"]){
                cell.inputField.text = selectedPickerRow;
          
                    cell.switchButton.on = true;
                cell.switchButton.enabled = true;
  
            }
        }
    }
    if(pickerView1.tag==1){
        for (XYZSearchTableViewCell *cell in _tableCells) {
            if([cell.inputField.placeholder isEqual:@"Sex"]){
                cell.inputField.text = selectedPickerRow;
                cell.switchButton.on = true;
                cell.switchButton.enabled = true;
            }
        }
    }
}
@end
