//
//  XYZSearchResultTableViewController.m
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSearchResultTableViewController.h"
#import "XYZSearchResultTableViewCell.h"
#import "XYZDataFileViewController.h"
#import "XYZAnnotationTableViewController.h"
#import "AppDelegate.h"

@interface XYZSearchResultTableViewController ()

@property CGFloat tableCellWidth;
@property BOOL unwinding;

@end

@implementation XYZSearchResultTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    XYZSearchResultTableViewCell *cell= [self.tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell"];
    _tableCellWidth = cell.textFieldSize.width;
    
    //add self to appDelegate
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app addController:self];
}

- (void) viewDidAppear:(BOOL)animated {
    _unwinding = NO;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        _unwinding = YES;
    }
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    XYZSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    XYZExperiment *experiment = [_searchResults objectAtIndex: indexPath.row];
    [cell setTextFieldText: [_experimentDescriber getDescriptionOf: experiment]];

    cell.index = indexPath.row;
    cell.experiement = experiment;
    cell.controller = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYZExperiment *experiment = [_searchResults objectAtIndex: indexPath.row];
    NSString *text = [_experimentDescriber getDescriptionOf: experiment];
    UIFont *font = [UIFont systemFontOfSize:14];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(self.tableCellWidth, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                             attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return ceilf(rect.size.height+25);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectRow: indexPath.row];
}

-(void) didSelectRow: (NSInteger) row
{
    if (!_unwinding) {
        _selectedExperiment = [_searchResults objectAtIndex: row];
        [self performSegueWithIdentifier:@"toFileList1" sender:self];
    }
}

- (IBAction)editButtonPressed:(id)sender
{
    if (!_unwinding) {
        [self performSegueWithIdentifier:@"toEditDisplay" sender:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toFileList1"] || [segue.identifier isEqualToString:@"toFileList2"]) {
        XYZDataFileViewController *nextVC = (XYZDataFileViewController *)[segue destinationViewController];
        nextVC.experiment = _selectedExperiment;
    } else if ([segue.identifier isEqualToString:@"toEditDisplay"]) {
        XYZAnnotationTableViewController *nextVC = (XYZAnnotationTableViewController *)[segue destinationViewController];
        nextVC.describer = _experimentDescriber;
    }
}

@end
