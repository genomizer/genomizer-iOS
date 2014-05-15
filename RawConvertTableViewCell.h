//
//  RawConvertTableViewCell.h
//  InLogger
//
//  Created by Linus Öberg on 14/05/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RawConvertTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *bowtie;
@property (weak, nonatomic) IBOutlet UITextField *genomeFile;
@property (weak, nonatomic) IBOutlet UITextField *smoothing;
@property (weak, nonatomic) IBOutlet UITextField *step;
@property (weak, nonatomic) IBOutlet UISwitch *samToGff;
@property (weak, nonatomic) IBOutlet UISwitch *gffToSgr;
@property (weak, nonatomic) IBOutlet UITextField *ratioCalc;
@property (weak, nonatomic) IBOutlet UITextField *ratioCalcSmoothing;
@end
