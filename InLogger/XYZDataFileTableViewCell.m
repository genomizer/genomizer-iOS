//
//  XYZDataFileTableViewCell.m
//  Genomizer
//
//  Class that represents a cell in the DataFile tableView.
//

#import "XYZDataFileTableViewCell.h"

@implementation XYZDataFileTableViewCell

- (IBAction)switchValueChanged:(UISwitch *)sender
{

    if (_switchButton.on) {
        [_controller.selectedFiles addExperimentFile:_file];
    } else {
        [_controller.selectedFiles removeExperimentFile:_file];
    }
}

- (IBAction)infoButtonTouchUpInside:(UIButton *)sender
{
    [_controller showInfoAbout:_file];
}

@end
