//
//  XYZAnnotationTableViewCell.h
//  InLogger
//
//  Created by Joel Viklund on 06/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZAnnotationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end
