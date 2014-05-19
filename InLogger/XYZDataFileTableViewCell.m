//
//  XYZDataFileTableViewCell.m
//  InLogger
//
//  Created by Joel Viklund on 15/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZDataFileTableViewCell.h"

@implementation XYZDataFileTableViewCell

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    NSLog(@"SWITCH");
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
