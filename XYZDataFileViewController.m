//
//  XYZDataFileViewController.m
//  Genomizer
//
//  Class that handles the Data File view for search results.
//

#import "XYZDataFileViewController.h"
#import "XYZSearchResultTableViewController.h"
#import "XYZExperimentFile.h"
#import "XYZTitleTableViewCell.h"
#import "XYZDataFileTableViewCell.h"
#import "ServerConnection.h"
#import "XYZSelectedFilesViewController.h"
#import "XYZPopupGenerator.h"
#import "XYZSelectTaskTableViewController.h"
#import "XYZFileContainer.h"
#import "AppDelegate.h"

@interface XYZDataFileViewController ()

@property (weak, nonatomic) IBOutlet UIView *infoAboutFile;
@property (weak, nonatomic) IBOutlet UITextView *infoFileTextField;
@property (weak, nonatomic) IBOutlet UIView *dimView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL animating;

@end

@implementation XYZDataFileViewController

/**
 * Method that runs when the view controller is loaded.
 * Also adds this viewcontroller to the list of loaded viewcontrollers in AppDelegate.
 *
 */
- (void) viewDidLoad
{
    [super viewDidLoad];
    _selectedFiles = [[XYZFileContainer alloc] init];
    
    //add self to appDelegate
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app addController:self];
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
- (void)setExperiment:(XYZExperiment *)experiment
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
    XYZDataFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataFilePrototypeCell" forIndexPath:indexPath];
    XYZExperimentFile *file = [[_experiment.files getFiles: indexPath.section] objectAtIndex:indexPath.row];
    cell.textField.text = [file getDescription];
    cell.switchButton.on = [_selectedFiles containsFile:file];
    cell.file = file;
    cell.controller = self;
    return cell;
}

/**
 * Method that is called when the 'Add to Selected Files' button is pressed.
 * If one or more files are selected, the addExperimentFile method in
 * XYZSelectedFilesViewController is used to add those files to the selected files view.
 *
 */
- (IBAction)addFilesToSelectedFilesOnTouchUpInside:(UIButton *)sender
{
    NSArray *selectedFiles = [_selectedFiles getFiles];
    for (NSInteger i = [selectedFiles count]; i > 0; i--) {
        XYZExperimentFile *file = [selectedFiles objectAtIndex:i-1];
        [XYZSelectedFilesViewController addExperimentFile: file];
        [_selectedFiles removeExperimentFile:file];
    }
    
    if ([selectedFiles count] > 0){
        [XYZPopupGenerator showPopupWithMessage:@"Files added to Selected Files."];
    } else {
        [XYZPopupGenerator showPopupWithMessage:@"Please select files to add to Selected Files"];
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
        [XYZPopupGenerator showPopupWithMessage:@"Please select files to convert."];
        return;
    } else if(![XYZExperimentFile multipleFileType: selectedFiles]) {
        FileType type = ((XYZExperimentFile *)selectedFiles[0]).type;
        if (type == RAW) {
            [self performSegueWithIdentifier:@"toSelectTask" sender:selectedFiles];
        }else{
            [XYZPopupGenerator showPopupWithMessage:@"Not yet implemented."];
        }
    }
    else{
        [XYZPopupGenerator showPopupWithMessage:@"Please select files of same type."];
    }
}

/**
 * Method for displaying detailed information about a given XYZExperimentFile.
 * The information will be shown in the _dimView object of this viewcontroller.
 *
 *@param file - the XYZExperimentFile for which information is to be shown.
 */
- (void) showInfoAbout: (XYZExperimentFile *) file
{
    _dimView.hidden = NO;
    _infoAboutFile.hidden = NO;
    _infoAboutFile.layer.cornerRadius = 5;
    _infoAboutFile.layer.masksToBounds = YES;
    
    _infoAboutFile.layer.borderWidth = 0.4;
    _infoAboutFile.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _infoFileTextField.text = [file getAllInfo];
    [[_infoFileTextField layer] setBorderColor : [[UIColor lightGrayColor] CGColor]];
    [[_infoFileTextField layer] setBorderWidth:0.4];
}

/**
 * Method for hiding the display for detailed information about a XYZExperimentFile.
 * This method is called when the 'Close' button in the detailed information view.
 *
 */
- (IBAction)closeFileInfo:(id)sender {
    _infoAboutFile.hidden = YES;
    _dimView.hidden = YES;
    
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
        XYZSelectTaskTableViewController *nextVC = (XYZSelectTaskTableViewController *)(navController.viewControllers[0]);
        nextVC.experimentFiles = sender;
        nextVC.fileType = ((XYZExperimentFile *)sender[0]).type;
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
