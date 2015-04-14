//
//  SelectTaskTableViewController.h
//  Genomizer
//
//  Class that lets the user select what type of fileConvert
//  the user want to pereform.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "SelectTaskTableViewController.h"
#import "ExperimentFile.h"

@interface SelectTaskTableViewController : TableViewController
@property NSMutableArray* experimentFiles;
@property FileType fileType;

- (NSArray *) tasksOfFileType: (FileType) fileType;

@end
