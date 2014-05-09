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

@interface XYZSelectedFilesViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *selectedFiles;
@property NSMutableArray *cells;

@end

@implementation XYZSelectedFilesViewController

static XYZExperiment * SELECTED_FILES = nil;

+ (void)initialize
{
    if (SELECTED_FILES == nil) {
        SELECTED_FILES = [[XYZExperiment alloc] init];
    }
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
    [_cells setObject:cell atIndexedSubscript:indexPath.row];
    NSLog(@"%d", [_selectedFiles count]);
    /*
    XYZExperimentFile *file = [[self arrayFromSection: indexPath.section] objectAtIndex:indexPath.row];
    cell.textField.text = [file getDescription];
    cell.switchButton.on = NO;
    cell.file = file;
    cell.tag = file.type;
    NSLog(@"section %d row %d", indexPath.section, indexPath.row);
    [_cells setObject:cell atIndexedSubscript:[self rowsBeforeSection:indexPath.section] + indexPath.row];
    */
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    XYZSelectTaskTableViewController *nextVC = (XYZSelectTaskTableViewController *)[[segue destinationViewController] topViewController];
    nextVC.fileType = _segmentedControl.selectedSegmentIndex;
    /*
    if ([segue.identifier isEqualToString:@"searchResult"]) {
        XYZSearchResultTableViewController *nextVC = (XYZSearchResultTableViewController *)[segue destinationViewController];
        nextVC.searchResults1 = self.searchResults;
        nextVC.experimentDescriber = _experimentDescriber;
    }
     */
}


@end
