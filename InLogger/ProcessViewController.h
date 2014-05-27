//
//  ProcessViewController.h
//  Genomizer
//
//  Created by Linus Öberg on 15/05/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZViewController.h"
#import "XYZExperimentFile.h"

@interface ProcessViewController : XYZViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (void) reportProcessStatusResult: (NSMutableArray*) result error: (NSError*) error;

@end
