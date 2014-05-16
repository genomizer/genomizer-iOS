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

@interface XYZSearchResultTableViewController ()

@property XYZExperimentDescriber *experimentDescriber;
@property CGFloat tableCellWidth;

@end

@implementation XYZSearchResultTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    XYZSearchResultTableViewCell *cell= [self.tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell"];
    _tableCellWidth = cell.textFieldSize.width;
    _experimentDescriber = [[XYZExperimentDescriber alloc] init];
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
