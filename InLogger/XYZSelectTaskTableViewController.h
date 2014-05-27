//
//  XYZSelectTaskTableViewController.h
//  InLogger
//
//  Created by Joel Viklund on 08/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZTableViewController.h"
#import "XYZSelectTaskTableViewController.h"
#import "XYZExperimentFile.h"

@interface XYZSelectTaskTableViewController : XYZTableViewController
@property NSMutableArray* experimentFiles;
@property FileType fileType;

- (NSArray *) tasksOfFileType: (FileType) fileType;

@end
