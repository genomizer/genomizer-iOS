//
//  XYZSelectedFilesViewController.m
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSelectedFilesViewController.h"
#import "XYZDataFileTableViewCell.h"

@interface XYZSelectedFilesViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *selectedFiles;

@end

@implementation XYZSelectedFilesViewController

static XYZExperiment * SELECTED_FILES = nil;

+ (void)initialize
{
    if (SELECTED_FILES == nil) {
        SELECTED_FILES = [[XYZExperiment alloc] init];
    }
}

+ (void)addExperimentFile:(XYZExperimentFile *) file
{
    [SELECTED_FILES addExperimentFile: file];
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
    switch (sender.selectedSegmentIndex) {
        case 0:
            _selectedFiles = SELECTED_FILES.rawFiles;
            _leftButton.hidden = YES;
            _centerButton.hidden = NO;
            _centerButton.titleLabel.text = @"Convert to profile";
            _rightButton.hidden = YES;
            break;
        case 1:
            _selectedFiles = SELECTED_FILES.profileFiles;
            _leftButton.hidden =  NO;
            _leftButton.titleLabel.text = @"Convert to region";
            _centerButton.hidden = YES;
            _rightButton.hidden = NO;
            _rightButton.titleLabel.text = @"Change genom release";
            break;
        case 2:
            _selectedFiles = SELECTED_FILES.regionFiles;
            _leftButton.hidden = YES;
            _centerButton.hidden = YES;
            _rightButton.hidden = YES;
            break;
        case 3:
            _selectedFiles = SELECTED_FILES.otherFiles;
            _leftButton.hidden = YES;
            _centerButton.hidden = YES;
            _rightButton.hidden = YES;
            break;
    }
    [_tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [_tableView reloadData];
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


@end
