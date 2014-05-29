//
//  XYZSelectTaskTableViewController.h
//  Genomizer
//
//  Class that lets the user select what type of fileConvert
//  the user want to pereform.
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
