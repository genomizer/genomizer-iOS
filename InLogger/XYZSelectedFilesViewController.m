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
#import <QuartzCore/QuartzCore.h>

@interface XYZSelectedFilesViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *infoAboutFile;
@property (weak, nonatomic) IBOutlet UITextView *infoFileTextField;
@property (weak, nonatomic) IBOutlet UIView *dimView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;

@property XYZExperimentFile *infoFile;
@property NSMutableArray *selectedFiles;
@property NSMutableArray *experimentFiles;
@property NSArray *pickerViewFields;
@property NSMutableArray *cells;

@end

@implementation XYZSelectedFilesViewController

static XYZExperiment * SELECTED_FILES = nil;
static XYZExperimentFile * INFO_FILE = nil;

+ (void)initialize
{
    if (SELECTED_FILES == nil) {
        SELECTED_FILES = [[XYZExperiment alloc] init];
    }
    if (INFO_FILE == nil) {
        INFO_FILE = [[XYZExperimentFile alloc] init];
    }
}
+ (void) addInfoFile:(XYZExperimentFile *) file{
    INFO_FILE = file;
    
    NSLog(@"file added %@", file.uploadedBy);
}
+ (void) addExperimentFile:(XYZExperimentFile *) file
{
    [SELECTED_FILES addExperimentFile: file];
    
}

+ (void) removeExperimentFile:(XYZExperimentFile *) file
{
    [SELECTED_FILES removeExperimentFile: file];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender
{
    [self updateTableViewAndButtons];
}

- (void) updateTableViewAndButtons
{
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _selectedFiles = SELECTED_FILES.rawFiles;
            break;
        case 1:
            _selectedFiles = SELECTED_FILES.profileFiles;
            break;
        case 2:
            _selectedFiles = SELECTED_FILES.regionFiles;
            break;
        case 3:
            _selectedFiles = SELECTED_FILES.otherFiles;
            break;
    }
    
    _cells = [[NSMutableArray alloc] initWithCapacity:[_selectedFiles count]];
    [_tableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateTableViewAndButtons];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedFiles = SELECTED_FILES.rawFiles;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_selectedFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYZDataFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataFilePrototypeCell" forIndexPath:indexPath];
    cell.textField.text = [[_selectedFiles objectAtIndex:indexPath.row] getDescription];
    cell.switchButton.on = YES;
    cell.file = [_selectedFiles objectAtIndex:indexPath.row];
    cell.infoButton.tag = indexPath.row;
    [_cells setObject:cell atIndexedSubscript:indexPath.row];
    NSLog(@"%d", [_selectedFiles count]);

    return cell;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSMutableArray *) getFilesFromSelectedCells
{
    NSMutableArray *files = [[NSMutableArray alloc] init];
    for (XYZDataFileTableViewCell *cell in _cells) {
        if (cell.switchButton.on) {
            [files addObject:cell.file];
        }
    }
    
    return files;
}

- (IBAction)removeFilesWhenTouchTrash:(UIBarButtonItem *)sender
{
    for (XYZExperimentFile *file in [self getFilesFromSelectedCells]) {
        [SELECTED_FILES removeExperimentFile:file];
    }
    
    [self updateTableViewAndButtons];
}
- (IBAction)selectTaskButton:(id)sender {
    [self createExperimentFiles];
      NSLog(@"prep segue ");
     [self performSegueWithIdentifier:@"convertTask" sender:_experimentFiles];
    
}
- (IBAction)infoFile:(UIButton*)sender {
      NSLog(@"prep segue %ld", (long)sender.tag);
    _dimView.hidden = NO;
    _infoAboutFile.hidden = NO;
    _infoAboutFile.layer.cornerRadius = 5;
    _infoAboutFile.layer.masksToBounds = YES;
    _tableView.editing = NO;
    [self.tableView endEditing:YES];
    _trashButton.enabled = NO;
    _infoAboutFile.layer.borderWidth = 0.4;
    _infoAboutFile.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _infoFileTextField.text = [[_selectedFiles objectAtIndex:sender.tag] getAllInfo];
    
    
}
- (IBAction)closeInfoFile:(id)sender {
    _infoAboutFile.hidden = YES;
     _dimView.hidden = YES;
    _trashButton.enabled =YES;
}

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"convertToRaw"]) {
        RawConvertViewController *nextVC = (RawConvertViewController *)[segue destinationViewController];
        nextVC.experimentFiles = _selectedFiles;
    }
}*/
- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    
}
-(void) createExperimentFiles{
     _experimentFiles = [[NSMutableArray alloc] init];
  for(XYZExperimentFile *file in [self getFilesFromSelectedCells]){
        NSMutableDictionary * currentFile = [[NSMutableDictionary alloc] init];
        [currentFile setObject:file.name forKey:@"filename"];
        [currentFile setObject:file.idFile forKey:@"fileId"];
        [currentFile setObject:file.expID forKey:@"expid"];
        [currentFile setObject:@"rawtoprofile" forKey:@"processtype"];
        [currentFile setObject:file.metaData forKey:@"metadata"];
        [currentFile setObject:file.grVersion forKey:@"genomeRelease"];
        [currentFile setObject:file.author forKey:@"author"];
        NSLog(@"currfile%@", currentFile);
        [_experimentFiles addObject:currentFile];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"convertTask"]) {
        XYZSelectTaskTableViewController *nextVC = (XYZSelectTaskTableViewController *)[segue destinationViewController];
        nextVC.experimentFiles = _experimentFiles;
        nextVC.fileType = _segmentedControl.selectedSegmentIndex;
    }
}


@end
