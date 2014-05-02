//
//  XYZSearchViewController.m
//  InLogger
//
//  Created by Joel Viklund on 25/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSearchViewController.h"
#import "XYZSearchTableViewCell.h"
#import "XYZSearchResultTableViewController.h"
#import "ServerConnection.h"
#import "XYZExperimentDescriber.h"

@interface XYZSearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *selectedFields;
@property NSArray *searchFields;
@property NSMutableArray *searchResults;
@property NSMutableDictionary *searchValues;
@property NSMutableArray *tableCells;

@end

@implementation XYZSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchFields = [self createSearchFields];
    [self.tableView reloadData];
    self.selectedFields = [[NSMutableArray alloc] init];
    self.tableCells = [[NSMutableArray alloc] init];
    
}

- (NSArray *) createSearchFields
{
    NSError *error;
    return [ServerConnection getAvailableAnnotations:&error];
    //return [NSMutableArray arrayWithObjects:@"experimentID", @"pubmedId" , @"Type of data", @"Species", @"Genom release", @"Cell-line", @"Developmental stage", @"Sex", @"Tissue", @"Processing", nil];
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
    // Return the number of rows in the section.
    return [self.searchFields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    XYZSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *annotation = [self.searchFields objectAtIndex:indexPath.row];
    cell.inputField.placeholder = [XYZExperimentDescriber formatAnnotation: annotation];
    cell.annotation = annotation;
    cell.inputField.tag = indexPath.row;
    cell.switchButton.enabled = false;
    cell.switchButton.on = false;
    cell.switchButton.tag = indexPath.row;
    cell.inputField.delegate = self;
    [_tableCells addObject:cell];
    return cell;
}
- (IBAction)searchButton:(id)sender {
    NSError *error;
    _searchValues = [NSMutableDictionary dictionary];
    for (XYZSearchTableViewCell *cell in _tableCells) {
        if (cell.switchButton.on) {
            [_searchValues setObject:cell.inputField.text forKey:cell.annotation];
        }
    }
    NSLog(@"asd: %@", _searchValues);
    self.searchResults = [ServerConnection search:nil error:&error];
   [self performSegueWithIdentifier:@"searchResult" sender:self.searchResults];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"searchResult"]) {
        XYZSearchResultTableViewController *nextVC = (XYZSearchResultTableViewController *)[segue destinationViewController];
        nextVC.searchResults1 = self.searchResults;
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];

    return NO;
}

- (IBAction)touchUpInsideSwitch:(id)sender {
    [self.view endEditing:YES];
}



@end
