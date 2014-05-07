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
#import "pickerView.h"
#import <QuartzCore/QuartzCore.h>
@interface XYZSearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *advancedView;

@property NSMutableArray *selectedFields;
@property NSArray *searchFields;
@property NSMutableArray *searchResults;
@property NSMutableDictionary *searchValues;
@property NSMutableArray *tableCells;
@property NSMutableDictionary *dict;
@property NSMutableArray *pickerViews;
@property XYZExperimentDescriber* experimentDescriber;
@property (weak, nonatomic) IBOutlet UITextView *pumedSearch;

@end

@implementation XYZSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchFields = [self createSearchFields];
    [self.tableView reloadData];
    self.selectedFields = [[NSMutableArray alloc] init];
    self.tableCells = [[NSMutableArray alloc] initWithCapacity:[_searchFields count]];
    _experimentDescriber = [[XYZExperimentDescriber alloc] init];
    [self createPickerViews];
}
- (void) createPickerViews{
    _pickerViews = [[NSMutableArray alloc] init];
    for(NSString *key in [_dict allKeys]){
        if(![[_dict objectForKey:key][0] isEqual:@"freetext"]){
            pickerView *myPickerView = [[pickerView alloc] initWithFrame:CGRectMake(0, 200, 100, 80)];
            myPickerView.tag = [[_dict allKeys] indexOfObject:key];
            myPickerView.dataPicker = [_dict objectForKey:key];
            myPickerView.delegate = (id)myPickerView.self;
            myPickerView.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:244/255.0f    alpha:1.0f];
            myPickerView.dataSource = (id)myPickerView.self;
            myPickerView.tableCells = self.tableCells;
            myPickerView.annotationsDict = self.dict;
            myPickerView.tableView = self.tableView;
            myPickerView.showsSelectionIndicator = YES;
            [_pickerViews addObject:myPickerView];
        }
    }
}

- (NSArray *) createSearchFields
{
    NSError *error;
    _dict = [[NSMutableDictionary alloc] init];
    _dict = [ServerConnection getAvailableAnnotations:&error];
    
     NSLog(@"eeee  %@", _dict);
   return [_dict allKeys];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchFields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    XYZSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *annotation = [self.searchFields objectAtIndex:indexPath.row];
    cell.inputField.placeholder = [XYZExperimentDescriber formatAnnotation:[self.searchFields objectAtIndex:indexPath.row]];
    cell.annotation = annotation;
    if(cell.inputField.text.length == 0) {
        cell.switchButton.enabled = false;
        cell.switchButton.on = false;
    }
    cell.inputField.delegate = self;
    cell.controller = self;
    [_tableCells setObject:cell atIndexedSubscript:indexPath.row];
    NSLog(@"ASDASD %lu", (unsigned long)[_tableCells count]);
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![[_dict objectForKey:textField.placeholder][0] isEqual:@"freetext"]) {
      
        int i = 0;
        for (XYZSearchTableViewCell *cell in _tableCells) {
            if([textField.placeholder isEqual:cell.inputField.placeholder]){
                break;
            }
            i++;
        }
        for(pickerView *pick in _pickerViews) {
            if(pick.tag == i) {
                textField.inputView = pick;
            }
        }
    }
    return YES;
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
        if (cell != nil && cell.switchButton.on) {
            [_searchValues setObject:cell.inputField.text forKey:cell.annotation];
        }
    }
    NSLog(@"asd: %lu %@", (unsigned long)[_tableCells count], _searchValues);
    self.searchResults = [ServerConnection search:[self createAnnotationsSearch] error:&error];
    [self.searchResults addObject:[XYZExperiment defaultExperiment]];
   [self performSegueWithIdentifier:@"searchResult" sender:self.searchResults];
}

- (IBAction)closeAdvancedSearch:(id)sender {
    _advancedView.hidden = YES;
     _tableView.userInteractionEnabled = YES;
    [_pumedSearch endEditing:YES];
}
- (IBAction)SearchQueryButtonTouched:(id)sender {
    NSError *error;
    self.searchResults = [ServerConnection search:_pumedSearch.text error:&error];
    if(error){
        [self showErrorMessage:@"Probably incorrect search query" title:error.domain];
    }
    else{
        [self performSegueWithIdentifier:@"searchResult" sender:self.searchResults];
    }
}

- (IBAction)showErrorMessage:(NSString*) error title:(NSString*) title
{
    UIAlertView *searchFailed = [[UIAlertView alloc]
                                initWithTitle:title message:error
                                delegate:nil cancelButtonTitle:@"Try again"
                                otherButtonTitles:nil];
    
    [searchFailed show];
}


- (IBAction)advancedSearchButton:(id)sender {
    _advancedView.hidden = NO;
    _advancedView.layer.cornerRadius = 5;
    _advancedView.layer.masksToBounds = YES;
    _tableView.editing = NO;
    [self.tableView endEditing:YES];
   // _tableView.alpha = 0.5;
    //_tableView.opaque = YES;
    _advancedView.layer.borderWidth = 0.4;
    _advancedView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pumedSearch.layer.cornerRadius = 5;
    _pumedSearch.layer.masksToBounds = YES;
    _pumedSearch.layer.borderWidth = 0.2;
    _pumedSearch.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pumedSearch.delegate = (id)self;
    [self.view bringSubviewToFront:_advancedView];
    _tableView.userInteractionEnabled = NO;
    _searchValues = [NSMutableDictionary dictionary];
    for (XYZSearchTableViewCell *cell in _tableCells) {
        if (cell != nil && cell.switchButton.on) {
            [_searchValues setObject:cell.inputField.text forKey:cell.annotation];
        }
    }
    _pumedSearch.text = [self createAnnotationsSearch];
    [_pumedSearch becomeFirstResponder ];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchResult"]) {
        XYZSearchResultTableViewController *nextVC = (XYZSearchResultTableViewController *)[segue destinationViewController];
        nextVC.searchResults1 = self.searchResults;
        nextVC.experimentDescriber = _experimentDescriber;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        NSError *error;
        self.searchResults = [ServerConnection search:_pumedSearch.text error:&error];
        if(error){
            [self showErrorMessage:@"Probably incorrect search query" title:error.domain];
        }
        else{
            [self performSegueWithIdentifier:@"searchResult" sender:self.searchResults];
        }
        return NO;
    }
    return YES;
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
