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

- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 117, 0);
    UITableViewCell *cell;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        cell = (UITableViewCell *) textField.superview.superview;
        
    } else {
        // Load resources for iOS 7 or later
        cell = (UITableViewCell *) textField.superview.superview.superview;
        // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Cell!
    }
    [_tableView scrollToRowAtIndexPath:[_tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

/*
- (IBAction)annotationInputFieldEditingDidBegin:(id)sender {
    //_tableView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
   // UITextField *textField = (UITextField *)(sender);
   // XYZSearchTableViewCell *cell = (XYZSearchTableViewCell *)[textField superview];
    //[_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath inSection: 2] animated:YES];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}*/
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
    if(cell.inputField.text.length == 0) {
        cell.switchButton.enabled = false;
        cell.switchButton.on = false;
    }
    cell.inputField.delegate = self;
    cell.controller = self;
    [_tableCells addObject:cell];
    return cell;
}

-(NSString*)createAnnotationsSearch
{
    int numberOfAnnotations = self.searchValues.count;
    int annotationsDone = 0;
     NSString *annoSearch = @"";
    for(int i=0;i < numberOfAnnotations-1;i++) {
        annoSearch = [annoSearch stringByAppendingString:@"("];
    }
    for(id key in self.searchValues){
        annotationsDone ++;
        NSString* value = [self.searchValues objectForKey:key];
        annoSearch = [annoSearch stringByAppendingString:value];
        annoSearch = [annoSearch stringByAppendingString:@"["];
        annoSearch = [annoSearch stringByAppendingString:key];
        if(annotationsDone == numberOfAnnotations) {
            annoSearch = [annoSearch stringByAppendingString:@"]"];
        } else {
            annoSearch = [annoSearch stringByAppendingString:@"]) AND "];
        }
    }
    return annoSearch;
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
    self.searchResults = [ServerConnection search:[self createAnnotationsSearch] error:&error];
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



- (void)hideKeyboardAndAdjustTable {
    [self.view endEditing:YES];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hideKeyboardAndAdjustTable];
    return NO;
}

- (IBAction)touchUpInsideSwitch:(id)sender {
    [self hideKeyboardAndAdjustTable];
}



@end
