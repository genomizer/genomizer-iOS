//
//  SelectedFilesViewController.m
//  Genomizer
//
//  Class that handles the files added from the searcResultView to the
//  selectedFilesView (this view).

#import "SelectedFilesViewController.h"
#import "DataFileTableViewCell.h"
#import "SelectTaskTableViewController.h"
#import "PopupGenerator.h"
#import "FileContainer.h"
#import "TabViewController.h"
@interface SelectedFilesViewController (){
     NSMutableArray *experiements;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UIButton *selectTaskToPerformButton;

@property NSMutableArray *filesToDisplay;
@property FileContainer *selectedFiles;

@end

@implementation SelectedFilesViewController

static FileContainer * FILES = nil;

+ (void)initialize
{
    if (FILES == nil) {
        FILES = [[FileContainer alloc] init];
        NSData *encodedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedFiles"];
        if(encodedData != nil){
            FILES = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
        }
    }
}

/**
 * Method that adds a experiment file to FileContainer.
 * Called by DataFileTableViewCell.
 */
+ (void) addExperimentFile:(ExperimentFile *) file{
    [FILES addExperimentFile: file];
    [SelectedFilesViewController updateSavedFilesStorage];
}

+(BOOL)containsExperimentFile:(ExperimentFile *) file{
    return [FILES containsFile:file];
}
/**
 * Method that removes a experiment file from the FileContainer.
 * Called by DataFileTableViewCell.
 */
+ (void) removeExperimentFile:(ExperimentFile *) file{
    [FILES removeExperimentFile: file];
    [SelectedFilesViewController updateSavedFilesStorage];
}
+(void)updateSavedFilesStorage{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:FILES];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:@"savedFiles"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * Method that executes when the segmentcontroll is changed.
 * i.e the user want to view selected profile-files instead 
 * of the raw-files the user is currently viewing.
 */
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender
{
    [self updateTableViewAndButtons];
}

/**
 * Executes when a switchbutton is pressed. 
 * @return if switch changed to ON - adds corresponding file to 
 *                                   the array selectedFiles.
 * @return if switch changed to OFF - removes corresponding file from
 *                                    the array selectedFiles.
 */
- (IBAction)fileSwitchValueChanged:(UISwitch *)sender{
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    
    while(![cell isKindOfClass:[UITableViewCell class]]){
        cell = (UITableViewCell *)cell.superview;
    }
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    ExperimentFile *file = _filesToDisplay[indexPath.section][indexPath.row];
    if (sender.on) {
        [_selectedFiles addExperimentFile:file];
    } else {
        [_selectedFiles removeExperimentFile:file];
    }
    
    _selectTaskToPerformButton.enabled = ([_selectedFiles numberOfFilesWithType:_segmentedControl.selectedSegmentIndex] > 0);
}

-(void)updateFiles{
    experiements = [FILES getAllExperimentIDsOfFileType:_segmentedControl.selectedSegmentIndex].mutableCopy;
    NSMutableArray *newFilesToDisplay = [[NSMutableArray alloc] init];
    for(NSString *expID in experiements){
        [newFilesToDisplay addObject:[FILES getAllExperimentsWithID:expID fileType:RAW]];
    }
    _filesToDisplay = newFilesToDisplay;
}
- (void) updateTableViewAndButtons
{
//    _filesToDisplay = [FILES getFiles:_segmentedControl.selectedSegmentIndex];
//    _selectTaskToPerformButton.enabled = ([_selectedFiles numberOfFilesWithType:_segmentedControl.selectedSegmentIndex] > 0);
//    [_tableView reloadData];
    [self updateFiles];

    [_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateTableViewAndButtons];
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _filesToDisplay = [FILES getFiles:RAW];
    
    _selectedFiles = [[FileContainer alloc] init];
    [self updateTableViewAndButtons];
    
    //add self to appDelegate
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Returns number of sections i tableView.
    return experiements.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Returns number of rows in tableView.
    if(_filesToDisplay.count < section){
        return 0;
    }
    return [(NSArray *)_filesToDisplay[section] count];
}

/**
 * This method sets up the tableview.
 * Creates a cell and puts data into it.
 * @param tableView - the tableview.
 * @param cellForRowAtIndexPath - what index in the tableView the
 *                                created cell will be added to.
 * @return a cell that will be added to the tableView.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataFilePrototypeCell" forIndexPath:indexPath];
    ExperimentFile *file = _filesToDisplay[indexPath.section][indexPath.row];
    cell.textField.text = [file getDescription];
    cell.switchButton.on = [_selectedFiles containsFile:file];
    //cell.file = [_selectedFiles objectAtIndex:indexPath.row];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return experiements[section];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    // Number of sections i pickerView.
    return 1;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        ExperimentFile *file = _filesToDisplay[indexPath.section][indexPath.row];
        [SelectedFilesViewController removeExperimentFile:file];
        [_selectedFiles removeExperimentFile:file];
        
        [self updateFiles];
        // Either delete some rows within a section (leaving at least one) or the entire section.
        if (_filesToDisplay.count > indexPath.section){
            // Section is not yet empty, so delete only the current row.
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
        else{
            // Section is now completely empty, so delete the entire section.
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                     withRowAnimation:UITableViewRowAnimationLeft];
        }
        
    }
}

- (FileType) getSelectedFileType
{
    // returns what file-type corresponding segmentcontroll refer to.
    return _segmentedControl.selectedSegmentIndex;
}

/** 
 * Method that executes when the trashbutton i top-right corner is pressed.
 *  @return Removes all selected files (those files that 
 *          have switchbutton set to "ON".)
 */
- (IBAction)removeFilesWhenTouchTrash:(UIBarButtonItem *)sender
{
    NSArray *files = [_selectedFiles getFiles: [self getSelectedFileType]];
    for (NSInteger i = [files count]; i > 0; i--) {
        ExperimentFile *file = [files objectAtIndex:i-1];
        [FILES removeExperimentFile:file];
        [_selectedFiles removeExperimentFile:file];
    }
    
    [PopupGenerator showPopupWithMessage:@"Files removed"];
    [self updateTableViewAndButtons];
}

/**
 * Executes when "selectTask"-button is pressed.
 * Some checks to see if files have the same speices.
 * @return calls method "preformSegueWithIdentifier".
 */
- (IBAction)selectTaskButton:(id)sender {
    NSArray *filesSelected = [_selectedFiles getFiles:[self getSelectedFileType]];
    if(filesSelected.count == 1) {
        [self performSegueWithIdentifier:@"convertTask" sender:self];
    } else if(filesSelected.count > 1){
        ExperimentFile *firstFile = filesSelected[0];
        NSString *specie = firstFile.species;
        for(int i = 1; i < filesSelected.count; i++){
            if(!([specie isEqualToString:[filesSelected[i] species]])){
                [PopupGenerator showPopupWithMessage:@"Files with diffrent speices selected"];
                break;
            }
            else if(i == filesSelected.count-1){
                [self performSegueWithIdentifier:@"convertTask" sender:self];
            }
        }
    }
}

/**
 * Executes when the "info"-button next to a file is pressed.
 * @return Shows a popup containing information about that file.
 */
- (IBAction)infoFile:(UIButton*)sender {
    ExperimentFile *file = _filesToDisplay[sender.tag];
    [(TabViewController *)self.tabBarController showInfoAboutFile:file];

}

//Pål did this
//-(void)fileAboutViewDidClose:(FileAboutView *)fav{
//    _trashButton.enabled = true;
//}
/**
 * Executes when "close"-button in the "infoFile"-popup is pressed.
 */
//- (IBAction)closeInfoFile:(id)sender {
//    _infoAboutFile.hidden = YES;
//    _dimView.hidden = YES;
//    _trashButton.enabled =YES;
//}

//Pål did this
//    NSString *infoText = @"Hejsan allihopa";//[[_filesToDisplay objectAtIndex:sender.tag] getAllInfo];
//    UIView *dimView = ({
//        UIView *v = [[UIView alloc] initWithFrame:self.view.frame];
//        v.backgroundColor = [UIColor blackColor];
//        v.alpha = 0.4;
//        v;
//    });
//    FileAboutView *fav = ({
//        float height = 150;
//        FileAboutView *fav = [[FileAboutView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2 - height/2, self.view.frame.size.width, height)];
//        fav.delegate = self;
//        [fav setText:infoText];
//        fav.dimView = dimView;
//        fav;
//    });
//
//    [self.tabBarController.view addSubview:dimView];
//    [self.tabBarController.view addSubview:fav];
//
//    _dimView.hidden = NO;
//    _infoAboutFile.hidden = NO;
//    _infoAboutFile.layer.cornerRadius = 5;
//    _infoAboutFile.layer.masksToBounds = YES;
//    _tableView.editing = NO;
//    [self.tableView endEditing:YES];
//
//    _trashButton.enabled = NO;
//    _infoAboutFile.layer.borderWidth = 0.4;
//    _infoAboutFile.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _infoFileTextField.text = [[_filesToDisplay objectAtIndex:sender.tag] getAllInfo];
//    [[_infoFileTextField layer] setBorderColor : [[UIColor lightGrayColor] CGColor]];
//    [[_infoFileTextField layer] setBorderWidth:0.4];
/*
 * Used to go back to this view from selectTaskTableViewController.
 */
- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    
}
/**
 * Method that stores information about what files are supposed to be converted
 * into the next viewContoller (SelectTaskViewController).
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"convertTask"]) {
        UINavigationController *navController = segue.destinationViewController;
        SelectTaskTableViewController *nextVC = (SelectTaskTableViewController *)(navController.viewControllers[0]);
        nextVC.experimentFiles = [FILES getFiles:[self getSelectedFileType]];
        nextVC.fileType = _segmentedControl.selectedSegmentIndex;
    }
}

@end
