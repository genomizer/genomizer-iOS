//
//  XYZDataFileTableViewCell.h
//  InLogger
//
//  Created by Joel Viklund on 30/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZDataFileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end
