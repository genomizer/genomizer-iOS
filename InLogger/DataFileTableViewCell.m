//
//  DataFileTableViewCell.m
//  Genomizer
//
//  Class that represents a cell in the DataFile tableView.
//

#import "DataFileTableViewCell.h"

@implementation DataFileTableViewCell

@synthesize starButton, switchButton, infoButton,textField;

- (IBAction)switchValueChanged:(UISwitch *)sender
{

    if (self.switchButton.on) {
        [_controller.selectedFiles addExperimentFile:_file];
    } else {
        [_controller.selectedFiles removeExperimentFile:_file];
    }
}

- (IBAction)infoButtonTouchUpInside:(UIButton *)sender
{
    [_controller showInfoAbout:_file];
}


-(IBAction)starButtonTapped:(UIButton *)sender{
    
}
@end
