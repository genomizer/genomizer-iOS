//
//  ProcessTableViewCell.h
//  Genomizer
//
//  Created by Linus Öberg on 15/05/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *file;
@property (weak, nonatomic) IBOutlet UILabel *process;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *added;
@property (weak, nonatomic) IBOutlet UILabel *started;
@property (weak, nonatomic) IBOutlet UILabel *finished;
@property (weak, nonatomic) IBOutlet UILabel *noProcesses;

@end
