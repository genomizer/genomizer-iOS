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
#import "TabBar2Controller.h"
#import "OptionsView.h"
@interface SelectedFilesViewController : ViewController<UITableViewDataSource, UITableViewDelegate, OptionsViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *selectTaskView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *selectTaskToPerformButton;


+ (void) addExperimentFile:(ExperimentFile *) file;
+ (void) removeExperimentFile:(ExperimentFile *) file;
- (IBAction) unwindToList:(UIStoryboardSegue *)segue;
- (IBAction)removeFilesWhenTouchTrash:(UIBarButtonItem *)sender;
+(BOOL)containsExperimentFile:(ExperimentFile *) file;
@end
