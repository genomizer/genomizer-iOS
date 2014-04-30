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

@interface XYZDataFileViewController ()

@property XYZExperiment *experiment;

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

NSInteger sortFunc(id id1, id id2, void *context)
{
    // Sort Function
    XYZExperimentFile *file1 = (XYZExperimentFile *)id1;
    XYZExperimentFile *file2 = (XYZExperimentFile *)id2;
    
    return [file1 compareTo:file2];
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
    cell.textField.text = @"ASD";
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
        return [self createDataFileCell:indexPath tableView:tableView withFile:[_experiment.profileFiles objectAtIndex:indexPath.row-2]];
    } else if (indexPath.row == [_experiment.rawFiles count] + [_experiment.profileFiles count] + 2) {
        return [self createTitleCell:indexPath tableView:tableView withTitle:@"Region Data"];
    } else if (indexPath.row < [_experiment.rawFiles count] + [_experiment.profileFiles count] + [_experiment.regionFiles count] + 3) {
        return [self createDataFileCell:indexPath tableView:tableView withFile:[_experiment.regionFiles objectAtIndex:indexPath.row-3]];
    } else if (indexPath.row == [_experiment.rawFiles count] + [_experiment.profileFiles count] + [_experiment.regionFiles count] + 3) {
        return [self createTitleCell:indexPath tableView:tableView withTitle:@"Other Files"];
    } else {
        return [self createDataFileCell:indexPath tableView:tableView withFile:[_experiment.otherFiles objectAtIndex:indexPath.row-4]];
    }
}

@end
