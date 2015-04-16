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

@property (readwrite, copy) void (^completionBlock)(NSError *error, NSString *message);
- (NSArray *) tasksOfFileType: (FileType) fileType;

@end
