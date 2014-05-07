//
//  XYZDataFileViewController.m
//  InLogger
//
//  Created by Joel Viklund on 30/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZDataFileViewController.h"
#import "XYZSearchResultTableViewController.h"
#import "XYZExperimentFile.h"
#import "XYZTitleTableViewCell.h"
#import "XYZDataFileTableViewCell.h"
#import "ServerConnection.h"

@interface XYZDataFileViewController ()

@property NSMutableArray *cells;

@end

@implementation XYZDataFileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _cells = [[NSMutableArray alloc] initWithCapacity:3];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setExperiment:(XYZExperiment *)experiment
{
    NSLog(@"ASDASDASDASDÖ LAKSDÖL KAÖSLDK ");
    _experiment = experiment;
   // _cells = [[NSMutableArray alloc] initWithCapacity:[_experiment numberOfFiles]];
    NSLog(@"Count: %d %d", [_cells count], [_experiment numberOfFiles]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
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
        case 4:
            return @"Other";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self arrayFromSection:section] count];
}

- (XYZDataFileTableViewCell *)createDataFileCell:(NSIndexPath *)indexPath tableView:(UITableView *)tableView withFile:(XYZExperimentFile *) file atIndex: (NSInteger)index
{
    NSString *cellIdentifier = @"DataFilePrototypeCell";
    XYZDataFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textField.text = [file getDescription];
    cell.switchButton.on = NO;
    cell.fileID = file.idFile;
    cell.tag = file.type;
    NSLog(@"Size; %d, %d", [_cells count], index);
    [_cells setObject:cell atIndexedSubscript:index];
    
    return cell;
}

- (NSInteger) rowsBeforSection: (NSInteger) section
{
    NSInteger rows = 0;
    for (int i = 0; i < section; i++) {
        rows += 0;
    }
    return rows;
}

- (NSArray *) arrayFromSection : (NSInteger)section
{
    switch (section) {
        case 0:
            return _experiment.rawFiles;
        case 1:
            return _experiment.profileFiles;
        case 2:
            return _experiment.regionFiles;
        case 3:
            return _experiment.otherFiles;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYZDataFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataFilePrototypeCell" forIndexPath:indexPath];
    XYZExperimentFile *file = [[self arrayFromSection: indexPath.section] objectAtIndex:indexPath.row];
    cell.textField.text = [file getDescription];
    cell.switchButton.on = NO;
    cell.fileID = file.idFile;
    cell.tag = file.type;
    [_cells setObject:cell atIndexedSubscript:indexPath.row];
    
    return cell;
}

- (void)showPopupWithMessage: (NSString *) message{
    UIAlertView *popup = [[UIAlertView alloc]
                          initWithTitle:@"" message:message
                          delegate:nil cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [popup show];
}

- (IBAction)addFilesToWorkspaceOnTouchUpInside:(UIButton *)sender
{
    //TODO - Send to server.
    NSMutableArray *fileIDs = [[NSMutableArray alloc] init];
    NSLog(@"Raw cells: %d", [_cells count]);
    for (NSInteger i = 0; i < [_cells count]; i++) {
        XYZDataFileTableViewCell *cell = [_cells objectAtIndex:i];
        if (cell.switchButton.on) {
            [fileIDs addObject:cell.fileID];
        }
    }
    
    if ([fileIDs count] > 0) {
        [self showPopupWithMessage:@"Files added to workspace."];
        
    } else {
        [self showPopupWithMessage:@"Please select files to add to workspace."];
    }
    
    for (XYZDataFileTableViewCell *cell in _cells) {
        cell.switchButton.on = NO;
    }
}

- (IBAction)convertToProfileOnTouchUpInside:(id)sender
{
    //TODO - Send to server.
    NSMutableArray *fileIDs = [[NSMutableArray alloc] init];
    FileType type = OTHER;
    NSLog(@"Raw cells: %d", [_cells count]);
    for (NSInteger i = 0; i < [_cells count]; i++) {
        XYZDataFileTableViewCell *cell = [_cells objectAtIndex:i];
        if (cell.switchButton.on ) {
            if (type == OTHER) {
                type = cell.tag;
            } else if (type != cell.tag){
                [self showPopupWithMessage:@"Ambiguous file types selected."];
                return;
            }
            [fileIDs addObject:cell.fileID];
        }
    }
    
    if ([fileIDs count] > 0) {
        if (type != RAW && type != PROFILE) {
            [self showPopupWithMessage:@"Please select raw or profile files."];
            return;
        }
        NSError *error;
        [ServerConnection convert:fileIDs error:&error];
        [self showPopupWithMessage:@"Convert order sent to server."];
    } else {
        [self showPopupWithMessage:@"Please select files to convert."];
    }
    
    for (XYZDataFileTableViewCell *cell in _cells) {
        cell.switchButton.on = NO;
    }
}


@end
