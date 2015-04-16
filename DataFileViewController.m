//
//  DataFileViewController.m
//  Genomizer
//
//  Class that handles the Data File view for search results.
//

#import "DataFileViewController.h"
#import "SearchResultTableViewController.h"
#import "ExperimentFile.h"
#import "TitleTableViewCell.h"
#import "DataFileTableViewCell.h"
#import "ServerConnection.h"
#import "SelectedFilesViewController.h"
#import "PopupGenerator.h"
#import "SelectTaskTableViewController.h"
#import "FileContainer.h"
#import "TabViewController.h"
@interface DataFileViewController ()

//@property (weak, nonatomic) IBOutlet UIView *infoAboutFile;
//@property (weak, nonatomic) IBOutlet UITextView *infoFileTextField;
@property (weak, nonatomic) IBOutlet UIView *dimView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL animating;

@end

@implementation DataFileViewController

/**
 * Method that runs when the view controller is loaded.
 * Also adds this viewcontroller to the list of loaded viewcontrollers in AppDelegate.
 *
 */
- (void) viewDidLoad
{
    [super viewDidLoad];
    _selectedFiles = [[FileContainer alloc] init];

}

- (void) viewDidAppear:(BOOL)animated {
    _animating = NO;
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
    _animating = YES;
    [super viewWillDisappear:animated];
}

/**
 * Method that sets the experiment for which the DataFile viewcontroller is to display
 * a file list.
 *
 */
- (void)setExperiment:(Experiment *)experiment
{
    _experiment = experiment;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Raw data";
        case 1:
            return @"Profile data";
        case 2:
            return @"Region data";
        case 3:
            return @"Other";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_experiment.files getFiles: section] count];
}

/**
 * Method that is called when a new cell is to be shown in the table view.
 * Re-uses an existing cell if possible, otherwise a new cell is generated.
 * It also sets the information in the cell.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataFilePrototypeCell" forIndexPath:indexPath];
    ExperimentFile *file = [[_experiment.files getFiles: indexPath.section] objectAtIndex:indexPath.row];
    cell.textField.text = [file getDescription];
    cell.switchButton.on = [_selectedFiles containsFile:file];
    cell.file = file;
    cell.controller = self;
    cell.starView.backgroundColor = [SelectedFilesViewController containsExperimentFile:file] ? [UIColor blackColor] : [UIColor blueColor];
    return cell;
}

/**
 * Method that is called when the 'Add to Selected Files' button is pressed.
 * If one or more files are selected, the addExperimentFile method in
 * SelectedFilesViewController is used to add those files to the selected files view.
 *
 */
- (IBAction)addFilesToSelectedFilesOnTouchUpInside:(UIButton *)sender
{
    NSArray *selectedFiles = [_selectedFiles getFiles];
    for (NSInteger i = [selectedFiles count]; i > 0; i--) {
        ExperimentFile *file = [selectedFiles objectAtIndex:i-1];
        if(![SelectedFilesViewController containsExperimentFile:file]){
            [SelectedFilesViewController addExperimentFile: file];
        }
        [_selectedFiles removeExperimentFile:file];
    }
    
    if ([selectedFiles count] > 0){
        [PopupGenerator showPopupWithMessage:@"Files added to Selected Files."];
    } else {
        [PopupGenerator showPopupWithMessage:@"Please select files to add to Selected Files"];
    }
    
    [_tableView reloadData];
}

/**
 * Method that is called when the 'Convert Files' button is pressed.
 * If one or more files are selected, the 'Select Task' view will be shown for those files.
 *
 */
- (IBAction)convertToProfileOnTouchUpInside:(id)sender
{
    if (_animating) {
        return;
    }
    NSArray *selectedFiles = [_selectedFiles getFiles];
    if ([selectedFiles count] == 0) {
        [PopupGenerator showPopupWithMessage:@"Please select files to convert."];
        return;
    } else if(![ExperimentFile multipleFileType: selectedFiles]) {
        FileType type = ((ExperimentFile *)selectedFiles[0]).type;
        if (type == RAW) {
            [self performSegueWithIdentifier:@"toSelectTask" sender:selectedFiles];
        }else{
            [PopupGenerator showPopupWithMessage:@"Not yet implemented."];
        }
    }
    else{
        [PopupGenerator showPopupWithMessage:@"Please select files of same type."];
    }
}

/**
 * Method for displaying detailed information about a given ExperimentFile.
 * The information will be shown in the _dimView object of this viewcontroller.
 *
 *@param file - the ExperimentFile for which information is to be shown.
 */
- (void) showInfoAbout: (ExperimentFile *) file
{
    [(TabViewController *)self.tabBarController showInfoAboutFile:file];

}

/**
 * Method for hiding the display for detailed information about a ExperimentFile.
 * This method is called when the 'Close' button in the detailed information view.
 *
 */
//- (IBAction)closeFileInfo:(id)sender {
//    _infoAboutFile.hidden = YES;
//    _dimView.hidden = YES;
//    
//}

/**
 * Method which is called when a segue is about to be performed.
 * It sends relevant data to the next view controller.
 *
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toSelectTask"]) {
        UINavigationController *navController = segue.destinationViewController;
        SelectTaskTableViewController *nextVC = (SelectTaskTableViewController *)(navController.viewControllers[0]);
        nextVC.experimentFiles = sender;
        nextVC.fileType = ((ExperimentFile *)sender[0]).type;
    }
}

/**
 * Used for returning to this view from subviews. Must be here even though it is empty.
 *
 */
- (IBAction) unwindToList:(UIStoryboardSegue *)segue
{
    
}

@end
