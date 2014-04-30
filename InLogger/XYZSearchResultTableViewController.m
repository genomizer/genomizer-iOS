//
//  XYZSearchResultTableViewController.m
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSearchResultTableViewController.h"
#import "ServerConnection.h"
#import "XYZSearchResultTableViewCell.h"
#import "XYZExperimentDescriber.h"

@interface XYZSearchResultTableViewController ()


@property CGFloat tableCellHeight;
@property XYZExperimentDescriber *experimentDescriber;

@end

@implementation XYZSearchResultTableViewController

- (void)viewDidLoad
{
    NSError *error;
    [super viewDidLoad];
    NSArray* annotations;
    NSDictionary * allResults= [ServerConnection search:annotations error:&error];
 
    _tableCellHeight = 120;
 //   self.searchFields = [self createSearchFields ];
  //  [self.tableView reloadData];
     NSLog(@"text %@", self.searchResults1);
    _experimentDescriber = [[XYZExperimentDescriber alloc] init];
    _searchResults1 = [self defaultResults ];
    
}

- (NSMutableArray *) defaultResults
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [results addObject:[XYZExperiment defaultExperiment]];
    [results addObject:[XYZExperiment defaultExperiment]];
    return results;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *) createSearchFields
{
    return [NSMutableArray arrayWithObjects:@"Experiment ID", @"Publication ID" , nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults1 count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    XYZSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    XYZExperiment *experiment = [_searchResults objectAtIndex: indexPath.row];
    [cell setTextFieldText: [_experimentDescriber getDescriptionOf: experiment]];
    _tableCellHeight = cell.frame.size.height;
    cell.index = indexPath.row;
    cell.experiement = experiment;
    cell.controller = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _tableCellHeight;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
