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
#import "RawConvertViewController.h"
#import "NavController.h"

@interface SelectedFilesViewController (){
    NSMutableArray *experiements;
    NSMutableArray *filesToDisplay;
}

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

+(void)removeAllExperimentFiles{
    [FILES removeAllFiles];
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
    UITableViewCell *cell = [self cellForButton:(UIButton *)sender];

    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    ExperimentFile *file = filesToDisplay[indexPath.section][indexPath.row];
    if (sender.on) {
        [_selectedFiles addExperimentFile:file];
    } else {
        [_selectedFiles removeExperimentFile:file];
    }
    
    [self updateSelectTaskView];
//    _selectTaskToPerformButton.enabled = ([_selectedFiles numberOfFilesWithType:_segmentedControl.selectedSegmentIndex] > 0);
}

-(void)updateFiles{
    experiements = [FILES getAllExperimentIDsOfFileType:_segmentedControl.selectedSegmentIndex].mutableCopy;
    NSMutableArray *newFilesToDisplay = [[NSMutableArray alloc] init];
    for(NSString *expID in experiements){
        [newFilesToDisplay addObject:[FILES getAllExperimentsWithID:expID fileType:RAW]];
    }
    filesToDisplay = newFilesToDisplay;
}

-(void)updateSelectTaskView{
    BOOL wasEnabled = _selectTaskToPerformButton.enabled;
    BOOL selectTaskEnabled = ([_selectedFiles numberOfFilesWithType:_segmentedControl.selectedSegmentIndex] > 0);
    _selectTaskToPerformButton.enabled = selectTaskEnabled;
    NSLog(@"size: %@", NSStringFromCGRect(_tableView.frame));
    if(!selectTaskEnabled && wasEnabled){
        [UIView animateWithDuration:0.1 animations:^{
//            _selectTaskView.transform = CGAffineTransformMakeTranslation(0, _selectTaskView.frame.size.height);
            _selectTaskView.frame = CGRectMake(_selectTaskView.frame.origin.x, _selectTaskView.frame.origin.y + _selectTaskView.frame.size.height, _selectTaskView.frame.size.width, _selectTaskView.frame.size.height);
            _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height + _selectTaskView.frame.size.height);
        }];
        
    } else if(selectTaskEnabled && !wasEnabled){
        [UIView animateWithDuration:0.1 animations:^{
//            _selectTaskView.transform = CGAffineTransformMakeTranslation(0, 0);
            _selectTaskView.frame = CGRectMake(_selectTaskView.frame.origin.x, _selectTaskView.frame.origin.y - _selectTaskView.frame.size.height, _selectTaskView.frame.size.width, _selectTaskView.frame.size.height);
            _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height - _selectTaskView.frame.size.height);
        }];
    }
}
- (void) updateTableViewAndButtons
{
//    filesToDisplay = [FILES getFiles:_segmentedControl.selectedSegmentIndex];

    [self updateSelectTaskView];
    [self updateFiles];
    [_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [self updateTableViewAndButtons];
    [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    filesToDisplay = [FILES getFiles:RAW];
    
    _selectedFiles = [[FileContainer alloc] init];
    _selectTaskToPerformButton.enabled = false;
//    [self updateTableViewAndButtons];
    
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
    if(filesToDisplay.count < section){
        return 0;
    }
    return [(NSArray *)filesToDisplay[section] count];
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
    ExperimentFile *file = filesToDisplay[indexPath.section][indexPath.row];
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
        
        ExperimentFile *file = filesToDisplay[indexPath.section][indexPath.row];
        [SelectedFilesViewController removeExperimentFile:file];
        [_selectedFiles removeExperimentFile:file];
        
        BOOL onlyOne = [filesToDisplay[indexPath.section] count] == 1;
        
        [self updateFiles];
        
        
        // Either delete some rows within a section (leaving at least one) or the entire section.
        if (!onlyOne){
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

#define kHeaderHeight 46.f
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderHeight)];
    v.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.f];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectInset(v.bounds, 15, 0)];
    l.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.f];
    [v addSubview:l];
    
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
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
//Pål did this
- (IBAction)removeFilesWhenTouchTrash:(UIBarButtonItem *)sender
{
    NSArray *files = [_selectedFiles getFiles: [self getSelectedFileType]];
    for (NSInteger i = [files count]; i > 0; i--) {
        ExperimentFile *file = [files objectAtIndex:i-1];
        [FILES removeExperimentFile:file];
        [_selectedFiles removeExperimentFile:file];
    }
    
//    [PopupGenerator showPopupWithMessage:@"Files removed"];
    [self updateTableViewAndButtons];
}

/**
 * Executes when "selectTask"-button is pressed.
 * Some checks to see if files have the same speices.
 * @return calls method "preformSegueWithIdentifier".
 */
- (IBAction)selectTaskButton:(id)sender {
    NSLog(@"self.tabbar: %@", self.tabBar2Controller);
    [(TabBar2Controller *)self.tabBar2Controller showOptions:@[@"Convert to raw"] delegate:self];
    
//    NSArray *filesSelected = [_selectedFiles getFiles:[self getSelectedFileType]];
//    
//    if(filesSelected.count == 1) {
//        [self performSegueWithIdentifier:@"convertTask" sender:self];
//    } else if(filesSelected.count > 1){
//        ExperimentFile *firstFile = filesSelected[0];
//        NSString *specie = firstFile.species;
//        for(int i = 1; i < filesSelected.count; i++){
//            if(!([specie isEqualToString:[filesSelected[i] species]])){
//                [PopupGenerator showPopupWithMessage:@"Files with diffrent speices selected"];
//                break;
//            }
//            else if(i == filesSelected.count-1){
//                [self performSegueWithIdentifier:@"convertTask" sender:self];
//            }
//        }
//    }
}

-(void)optionsView:(OptionsView *)ov selectedIndex:(NSUInteger)index{
    [self optionsViewDidClose:ov];
    
    if(index == 0){
        NavController *nextNVC = [self.storyboard instantiateViewControllerWithIdentifier:@"rawConvertNav"];
        nextNVC.tabBar2Controller = (TabBar2Controller *)self.tabBar2Controller;
        
        RawConvertViewController *nextVC = nextNVC.childViewControllers.firstObject;
        nextVC.experimentFiles = [FILES getFiles:[self getSelectedFileType]];
        nextVC.ratio = true;
        nextVC.completionBlock = ^(NSError *error, NSString *message){
//            NSLog(@"task finished: %@ %@", message, error.userInfo);
//            [(TabBar2Controller *)self.tabBar2Controller showPopDownWithTitle:@"Convert sent" andMessage:@"Convert request was successfully sent to server" type:@"success"];
        };
        [self.tabBar2Controller presentViewController:nextNVC animated:true completion:nil];
    }
    
}
-(void)optionsViewDidClose:(OptionsView *)ov{
    [(TabBar2Controller *)self.tabBar2Controller zoomViewRestore];
}
/**
 * Executes when the "info"-button next to a file is pressed.
 * @return Shows a popup containing information about that file.
 */
- (IBAction)infoFile:(UIButton*)sender {
    UITableViewCell *cell = [self cellForButton:sender];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    ExperimentFile *file = filesToDisplay[indexPath.section][indexPath.row];
    [(TabBar2Controller *)self.tabBar2Controller showInfoAboutFile:file];

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
//    NSString *infoText = @"Hejsan allihopa";//[[filesToDisplay objectAtIndex:sender.tag] getAllInfo];
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
//    [self.tabBar2Controller.view addSubview:dimView];
//    [self.tabBar2Controller.view addSubview:fav];
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
//    _infoFileTextField.text = [[filesToDisplay objectAtIndex:sender.tag] getAllInfo];
//    [[_infoFileTextField layer] setBorderColor : [[UIColor lightGrayColor] CGColor]];
//    [[_infoFileTextField layer] setBorderWidth:0.4];
/*
 * Used to go back to this view from selectTaskTableViewController.
 */
- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    
}
                                                       
-(UITableViewCell *)cellForButton:(UIButton *)b{
    UITableViewCell *cell = (UITableViewCell *)b.superview;
    while(![cell isKindOfClass:[UITableViewCell class]]){
        cell = (UITableViewCell *)cell.superview;
    }
    return cell;
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
