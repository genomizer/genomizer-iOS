//
//  XYZSelectedFilesViewController.h
//  Genomizer
//
//  Class that handles the files added from the searcResultView to the
//  selectedFilesView (this view).
//

#import <UIKit/UIKit.h>
#import "XYZViewController.h"
#import "XYZExperiment.h"


@interface XYZSelectedFilesViewController : XYZViewController

+ (void) addExperimentFile:(XYZExperimentFile *) file;
+ (void) removeExperimentFile:(XYZExperimentFile *) file;
- (IBAction) unwindToList:(UIStoryboardSegue *)segue;

@end
