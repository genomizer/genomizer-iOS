//
//  SelectedFilesViewController.h
//  Genomizer
//
//  Class that handles the files added from the searcResultView to the
//  selectedFilesView (this view).
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Experiment.h"

@interface SelectedFilesViewController : ViewController<UITableViewDataSource, UITableViewDelegate>

+ (void) addExperimentFile:(ExperimentFile *) file;
+ (void) removeExperimentFile:(ExperimentFile *) file;
- (IBAction) unwindToList:(UIStoryboardSegue *)segue;
+(BOOL)containsExperimentFile:(ExperimentFile *) file;
@end
