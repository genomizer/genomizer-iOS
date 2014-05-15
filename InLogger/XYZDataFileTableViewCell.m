//
//  XYZDataFileTableViewCell.m
//  InLogger
//
//  Created by Joel Viklund on 15/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZDataFileTableViewCell.h"

@implementation XYZDataFileTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    _file.selected = _switchButton.on;
}

- (IBAction)infoButtonTouchUpInside:(UIButton *)sender
{
    [_controller showInfoAbout:_file];
}

@end
