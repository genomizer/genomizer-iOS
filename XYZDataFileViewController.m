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

@property NSMutableArray *rawCells;

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
    _rawCells = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    XYZSearchResultTableViewController *source = [segue sourceViewController];
    _experiment = source.selectedExperiment;
    NSLog(@"Unwind: %d", [_experiment numberOfFiles]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_experiment numberOfFiles] + 4;
}

- (XYZTitleTableViewCell *)createTitleCell:(NSIndexPath *)indexPath tableView:(UITableView *)tableView withTitle:(NSString *) title
{
    NSString *cellIdentifier = @"TitlePrototypeCell";
    XYZTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textField.text = title;
    return cell;
}

- (XYZDataFileTableViewCell *)createDataFileCell:(NSIndexPath *)indexPath tableView:(UITableView *)tableView withFile:(XYZExperimentFile *) file
{
    NSString *cellIdentifier = @"DataFilePrototypeCell";
    XYZDataFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textField.text = [file getDescription];
    cell.switchButton.on = NO;
    cell.fileID = file.idFile;
    if (file.type == RAW) {
        [_rawCells addObject:cell];
    } else {
        cell.switchButton.hidden = YES;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
    if (indexPath.row == 0) {
        return [self createTitleCell:indexPath tableView:tableView withTitle: @"Raw Data"];
    } else if (indexPath.row < [_experiment.rawFiles count] + 1) {
        return [self createDataFileCell:indexPath tableView:tableView withFile:[_experiment.rawFiles objectAtIndex:indexPath.row-1]];
    } else if (indexPath.row == [_experiment.rawFiles count] + 1) {
        return [self createTitleCell:indexPath tableView:tableView withTitle:@"Profile Data"];
    } else if (indexPath.row < [_experiment.rawFiles count] + [_experiment.profileFiles count] + 2) {
        return [self createDataFileCell:indexPath tableView:tableView withFile:[_experiment.profileFiles objectAtIndex:indexPath.row-[_experiment.rawFiles count]-2]];
    } else if (indexPath.row == [_experiment.rawFiles count] + [_experiment.profileFiles count] + 2) {
        return [self createTitleCell:indexPath tableView:tableView withTitle:@"Region Data"];
    } else if (indexPath.row < [_experiment.rawFiles count] + [_experiment.profileFiles count] + [_experiment.regionFiles count] + 3) {
        return [self createDataFileCell:indexPath tableView:tableView withFile:[_experiment.regionFiles objectAtIndex:indexPath.row-[_experiment.rawFiles count]-[_experiment.profileFiles count]-3]];
    } else if (indexPath.row == [_experiment.rawFiles count] + [_experiment.profileFiles count] + [_experiment.regionFiles count] + 3) {
        return [self createTitleCell:indexPath tableView:tableView withTitle:@"Other Files"];
    } else {
        return [self createDataFileCell:indexPath tableView:tableView withFile:[_experiment.otherFiles objectAtIndex:indexPath.row-[_experiment.rawFiles count]-[_experiment.profileFiles count]-[_experiment.regionFiles count]-4]];
    }
}

- (void)showPopupWithMessage: (NSString *) message{
    UIAlertView *popup = [[UIAlertView alloc]
                          initWithTitle:@"" message:message
                          delegate:nil cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [popup show];
}

- (IBAction)convertToProfileOnTouchUpInside:(id)sender {
    //TODO - Send to server.
    NSMutableArray *fileIDs = [[NSMutableArray alloc] init];
    NSLog(@"Raw cells: %d", [_rawCells count]);
    NSInteger numOfOn = 0;
    for (NSInteger i = 0; i < [_rawCells count]; i++) {
        XYZDataFileTableViewCell *cell = [_rawCells objectAtIndex:i];
        if (cell.switchButton.on) {
            [fileIDs addObject:cell.fileID];
            numOfOn ++;
        }
    }
    
    if (numOfOn > 0) {
        NSError *error;
        [ServerConnection convert:fileIDs error:&error];
        [self showPopupWithMessage:@"Convert order sent to server"];
    } else {
        [self showPopupWithMessage:@"Please select files to convert!"];
    }
    
    
    
    for (XYZDataFileTableViewCell *cell in _rawCells) {
        cell.switchButton.on = NO;
    }
    
    
}


@end
