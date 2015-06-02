//
//  DataFileViewController.m
//  Genomizer
//
//  Class that handles the Data File view for search results.
//

#import "DataFileViewController.h"
#import "SearchResultTableViewController.h"
#import "DataFileTableViewCell.h"
#import "SelectedFilesViewController.h"
#import "PopupGenerator.h"
#import "SelectTaskTableViewController.h"
#import "Process2ViewController.h"

@interface DataFileViewController (){
    NSMutableArray *filesToProcessing;
}

@property (weak, nonatomic) IBOutlet UIView *dimView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL animating;

@end

@implementation DataFileViewController
@synthesize processButton;

/**
 * Method that runs when the view controller is loaded.
 * Also adds this viewcontroller to the list of loaded viewcontrollers in AppDelegate.
 *
 */
- (void) viewDidLoad
{
    [super viewDidLoad];
    _selectedFiles = [[FileContainer alloc] init];
    filesToProcessing = [[NSMutableArray alloc] init];

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

-(NSInteger)timesAdded:(ExperimentFile *)file{
    NSInteger times = 0;
    for(ExperimentFile *f in filesToProcessing){
        if([file isEqual:f]){
            times++;
        }
    }
    return times;
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
    cell.textField.text = file.name;
    cell.fileSize.text = file.filesize;
    cell.switchButton.on = [_selectedFiles containsFile:file];
    cell.file = file;
    cell.controller = self;
    
    NSInteger timesAdded = [self timesAdded:file];
    if(timesAdded > 0){
        cell.numberAddedLabel.text = [NSString stringWithFormat:@"(%d)", timesAdded];
    } else{
        cell.numberAddedLabel.text = @"";
    }
//    BOOL alreadyStared =[SelectedFilesViewController containsExperimentFile:file];
//    NSString *buttonImageName = alreadyStared ? @"Star" : @"Unstar";
//    [cell.starButton setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
//    cell.starButton.tag = alreadyStared;
    
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


-(IBAction)starButtonTapped:(UIButton *)sender{
//    BOOL alreadyStared = sender.tag;
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    while(![cell isKindOfClass:[UITableViewCell class]]){
        cell = (UITableViewCell *)cell.superview;
    }
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    ExperimentFile *file = [[_experiment.files getFiles: indexPath.section] objectAtIndex:indexPath.row];
    NSArray *fileComps = [file.name componentsSeparatedByString:@"."];
    NSString *extenstion = fileComps.lastObject;
    for(ExperimentFile *f in filesToProcessing){
        NSArray *fileNameComps = [f.name componentsSeparatedByString:@"."];
        NSString *ext = fileNameComps.lastObject;
        if(![ext isEqualToString:extenstion]){
            [self.tabBar2Controller showPopDownWithTitle:@"Multiple file types" andMessage:@"Multiple file types can't be sent to process at the same time." type:@"error"];
            return;
        }
    }
    [filesToProcessing addObject:file];
    NSLog(@"filesToProcess: %@", filesToProcessing);
    [processButton setTitle:[NSString stringWithFormat:@"Process (%d)", filesToProcessing.count] forState:UIControlStateNormal];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    if(alreadyStared){
//        //Unstar
//        [SelectedFilesViewController removeExperimentFile:file];
//    } else {
//        //Star
//        [SelectedFilesViewController addExperimentFile:file];
//    }
//    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(IBAction)clearButtonTapped:(id)sender{
    [filesToProcessing removeAllObjects];
    [processButton setTitle:@"Process" forState:UIControlStateNormal];
    [self.tableView reloadData];
}
/**
 * Method that is called when the 'Convert Files' button is pressed.
 * If one or more files are selected, the 'Select Task' view will be shown for those files.
 *
 */
- (IBAction)convertToProfileOnTouchUpInside:(id)sender
{
    NSLog(@"Send to process");
    if(filesToProcessing.count == 0){
        [self.tabBar2Controller showPopDownWithTitle:@"No files added" andMessage:@"Add some files to process before proceding" type:@"error"];
        return;
    }
    Process2ViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"process2"];
    pvc.filesToProcess = filesToProcessing;
    [self.navigationController pushViewController:pvc animated:true];
    
//    if (_animating) {
//        return;
//    }
//    NSArray *selectedFiles = [_selectedFiles getFiles];
//    if ([selectedFiles count] == 0) {
//        [PopupGenerator showPopupWithMessage:@"Please select files to convert."];
//        return;
//    } else if(![ExperimentFile multipleFileType: selectedFiles]) {
//        FileType type = ((ExperimentFile *)selectedFiles[0]).type;
//        if (type == RAW) {
//            [self performSegueWithIdentifier:@"toSelectTask" sender:selectedFiles];
//        }else{
//            [PopupGenerator showPopupWithMessage:@"Not yet implemented."];
//        }
//    }
//    else{
//        [PopupGenerator showPopupWithMessage:@"Please select files of same type."];
//    }
}

/**
 * Method for displaying detailed information about a given ExperimentFile.
 * The information will be shown in the _dimView object of this viewcontroller.
 *
 *@param file - the ExperimentFile for which information is to be shown.
 */
- (void) showInfoAbout: (ExperimentFile *) file
{
    [self.tabBar2Controller showInfoAboutFile:file];
}


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
