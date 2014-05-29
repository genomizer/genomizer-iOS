//
//  XYZDataFileViewController.m
//  Genomizer
//
//  Class that handles the Data File view for search results.
//

#import <UIKit/UIKit.h>
#import "XYZExperiment.h"
#import "XYZViewController.h"

@interface XYZDataFileViewController : XYZViewController

@property (nonatomic) XYZExperiment *experiment;
@property XYZFileContainer *selectedFiles;

- (IBAction) unwindToList:(UIStoryboardSegue *)segue;
- (void) showInfoAbout: (XYZExperimentFile *) file;

@end
