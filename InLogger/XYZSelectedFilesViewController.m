//
//  XYZSelectedFilesViewController.m
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSelectedFilesViewController.h"
#import "XYZDataFileTableViewCell.h"
#import "XYZSelectTaskTableViewController.h"
#import "XYZPopupGenerator.h"
#import "XYZFileContainer.h"

@interface XYZSelectedFilesViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *infoAboutFile;
@property (weak, nonatomic) IBOutlet UITextView *infoFileTextField;
@property (weak, nonatomic) IBOutlet UIView *dimView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UIButton *selectTaskToPerformButton;

@property NSMutableArray *filesToDisplay;
@property XYZFileContainer *selectedFiles;

@end

@implementation XYZSelectedFilesViewController

static XYZFileContainer * FILES = nil;

+ (void)initialize
{
    if (FILES == nil) {
        FILES = [[XYZFileContainer alloc] init];
    }
}

+ (void) addExperimentFile:(XYZExperimentFile *) file
{
    NSLog(@"File Added");
    [FILES addExperimentFile: file];
}

+ (void) removeExperimentFile:(XYZExperimentFile *) file
{
    [FILES removeExperimentFile: file];
}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender
{
    [self updateTableViewAndButtons];
}

- (IBAction)fileSwitchValueChanged:(UISwitch *)sender
{
    XYZExperimentFile *file = [_filesToDisplay objectAtIndex:sender.tag];
    if (sender.on) {
        [_selectedFiles addExperimentFile:file];
    } else {
        [_selectedFiles removeExperimentFile:file];
    }
    
    _selectTaskToPerformButton.enabled = ([_selectedFiles numberOfFilesWithType:_segmentedControl.selectedSegmentIndex] > 0);
}

- (void) updateTableViewAndButtons
{
    _filesToDisplay = [FILES getFiles:_segmentedControl.selectedSegmentIndex];
    
    _selectTaskToPerformButton.enabled = ([_selectedFiles numberOfFilesWithType:_segmentedControl.selectedSegmentIndex] > 0);
    [_tableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateTableViewAndButtons];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _filesToDisplay = [FILES getFiles:RAW];
    _selectedFiles = [[XYZFileContainer alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_filesToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYZDataFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataFilePrototypeCell" forIndexPath:indexPath];
    XYZExperimentFile *file = [_filesToDisplay objectAtIndex:indexPath.row];
    cell.textField.text = [file getDescription];
    cell.switchButton.on = [_selectedFiles containsFile:file];
    //cell.file = [_selectedFiles objectAtIndex:indexPath.row];
    cell.infoButton.tag = indexPath.row;
    cell.switchButton.tag = indexPath.row;
    return cell;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (FileType) getSelectedFileType
{
    return _segmentedControl.selectedSegmentIndex;
}

- (IBAction)removeFilesWhenTouchTrash:(UIBarButtonItem *)sender
{
    NSArray *files = [_selectedFiles getFiles: [self getSelectedFileType]];
    for (NSInteger i = [files count]; i > 0; i--) {
        XYZExperimentFile *file = [files objectAtIndex:i-1];
        [FILES removeExperimentFile:file];
        [_selectedFiles removeExperimentFile:file];
    }
    
    [XYZPopupGenerator showPopupWithMessage:@"Files removed"];
    
    [self updateTableViewAndButtons];
}

- (IBAction)selectTaskButton:(id)sender {
     [self performSegueWithIdentifier:@"convertTask" sender:self];
}

- (IBAction)infoFile:(UIButton*)sender {
    _dimView.hidden = NO;
    _infoAboutFile.hidden = NO;
    _infoAboutFile.layer.cornerRadius = 5;
    _infoAboutFile.layer.masksToBounds = YES;
    _tableView.editing = NO;
    [self.tableView endEditing:YES];
    _trashButton.enabled = NO;
    _infoAboutFile.layer.borderWidth = 0.4;
    _infoAboutFile.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _infoFileTextField.text = [[_filesToDisplay objectAtIndex:sender.tag] getAllInfo];
    [[_infoFileTextField layer] setBorderColor : [[UIColor lightGrayColor] CGColor]];
    [[_infoFileTextField layer] setBorderWidth:0.4];
}

- (IBAction)closeInfoFile:(id)sender {
    _infoAboutFile.hidden = YES;
     _dimView.hidden = YES;
    _trashButton.enabled =YES;
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"convertTask"]) {
        UINavigationController *navController = segue.destinationViewController;
        XYZSelectTaskTableViewController *nextVC = (XYZSelectTaskTableViewController *)(navController.viewControllers[0]);
        nextVC.experimentFiles = [FILES getFiles:[self getSelectedFileType]];
        nextVC.fileType = _segmentedControl.selectedSegmentIndex;
    }
}

@end
