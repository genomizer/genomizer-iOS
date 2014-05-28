//
//  XYZSearchViewController.m
//  InLogger
//
//  Created by Joel Viklund on 25/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSearchViewController.h"
#import "XYZSearchResultTableViewController.h"
#import "ServerConnection.h"
#import "XYZPopupGenerator.h"
#import "XYZSearchTableViewCell.h"
#import "XYZAnnotation.h"
#import "XYZPubMedBuilder.h"
#import "AppDelegate.h"

@interface XYZSearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *advancedView;
@property (weak, nonatomic) IBOutlet UITextView *pubmedTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property bool searching;

@end

@implementation XYZSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _spinner.hidesWhenStopped = YES;
    //add self to appDelegate
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app addController:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self annotationsIsStarting];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [ServerConnection getAvailableAnnotations:self];
    _pickerView = [self createPickerView];
    _toolBar = [self createPickerViewToolBar:_pickerView];
    [self.tableView reloadData];
    _searching = NO;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void) reportAnnotationResult: (NSArray*) result error: (NSError*) error {
    
    if(error == nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self annotationsIsFinishedWithResult: result];
        });
    } else
    {
        [XYZPopupGenerator showErrorMessage:error];
        [self annotationsIsFinishedWithResult: nil];
    }
}

- (void)scrollToCell: (UITableViewCell *) cell
{
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 117, 0);
    [_tableView scrollToRowAtIndexPath:[_tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_annotations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    XYZSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    XYZAnnotation *annotation = [_annotations objectAtIndex:indexPath.row];
    cell.inputField.placeholder = [annotation getFormatedName];
    cell.annotation = annotation;
    cell.controller = self;
    cell.switchButton.on = annotation.selected;
    cell.switchButton.enabled = !_searching;
    cell.inputField.enabled = !_searching;
    
    if (annotation.value == nil) {
        cell.inputField.text = @"";
    } else {
        cell.inputField.text = annotation.value;
    }
    
    if (![annotation isFreeText]) {
        cell.inputField.inputView = _pickerView;
        cell.inputField.inputAccessoryView = _toolBar;
    } else {
        cell.inputField.inputView = nil;
        cell.inputField.inputAccessoryView = nil;
    }
    return cell;
}

- (IBAction)searchButton:(id)sender {
    [self searchIsStarting];
    NSArray *selectedAnnotations = [self getSelectedAnnotations];
    [ServerConnection search:[XYZPubMedBuilder createAnnotationsSearch: selectedAnnotations] withContext:self];
}
- (void) annotationsIsFinishedWithResult: (NSArray *) result
{
    if(_annotations == nil || (result != nil && ![_annotations isEqualToArray:result])) {
        _annotations = result;
        [_tableView reloadData];
    }
    _searchButton.enabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) annotationsIsStarting
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _searchButton.enabled = NO;
}

- (void) searchIsFinished
{
    [_spinner stopAnimating];
    _searchButton.enabled = YES;
    _searchButton.hidden = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    _searching = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) searchIsStarting
{
    _spinner.hidden = NO;
    [_spinner startAnimating];
    _searchButton.enabled = NO;
    _searchButton.hidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    _searching = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) reportSearchResult: (NSMutableArray*) result error: (NSError*) error
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    if(!app.userIsLoggingOut)
    {
        if(error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self searchIsFinished];
                [XYZPopupGenerator showErrorMessage:error];
            });
        } else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self searchIsFinished];
                [self performSegueWithIdentifier:@"searchResult" sender:result];
            });
        }
    } else{
        NSLog(@"success");
    }
}

- (NSArray *) getSelectedAnnotations
{
    NSMutableArray *selectedAnnotations = [[NSMutableArray alloc] init];
    for (XYZAnnotation *annotation in _annotations) {
        if (annotation.selected) {
            [selectedAnnotations addObject:annotation];
        }
    }
    return selectedAnnotations;
}

- (IBAction)closeAdvancedSearch:(id)sender {
    _advancedView.hidden = YES;
    _tableView.userInteractionEnabled = YES;
    [_pubmedTextView endEditing:YES];
}

- (IBAction)searchQueryButtonTouched:(id)sender {
    
    [self searchIsStarting];
    
    //send search
    [ServerConnection search:_pubmedTextView.text withContext:self];
    _advancedView.hidden = YES;
    _tableView.userInteractionEnabled = YES;
    [_pubmedTextView endEditing:YES];
}

- (IBAction)advancedSearchButton:(id)sender {
    _advancedView.hidden = NO;
    _advancedView.layer.cornerRadius = 5;
    _advancedView.layer.masksToBounds = YES;
    _tableView.editing = NO;
    [self.tableView endEditing:YES];
    _advancedView.layer.borderWidth = 0.4;
    _advancedView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pubmedTextView.layer.cornerRadius = 5;
    _pubmedTextView.layer.masksToBounds = YES;
    _pubmedTextView.layer.borderWidth = 0.2;
    _pubmedTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pubmedTextView.delegate = (id)self;
    [self.view bringSubviewToFront:_advancedView];
    _tableView.userInteractionEnabled = NO;
    NSArray *selectedAnnotations = [self getSelectedAnnotations];
    _pubmedTextView.text = [XYZPubMedBuilder createAnnotationsSearch: selectedAnnotations];
    [_pubmedTextView becomeFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchResult"]) {
        XYZSearchResultTableViewController *nextVC = (XYZSearchResultTableViewController *)[segue destinationViewController];
        nextVC.searchResults = sender;
        nextVC.experimentDescriber = [[XYZExperimentDescriber alloc] initWithAnnotations: _annotations];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self searchIsStarting];
        [self closeAdvancedSearch:nil];
        [ServerConnection search:_pubmedTextView.text withContext:self];
        return NO;
    }
    return YES;
}

- (void)hideKeyboardAndAdjustTable {
    [self.view endEditing:YES];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _pickerView.delegate = nil;
    _pickerView.dataSource = nil;
    [_tableView reloadData];
}

- (UIToolbar *) createPickerViewToolBar: (UIPickerView *) pickerView
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, pickerView.bounds.size.width, 44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    [toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    return toolBar;
}
- (UIPickerView *) createPickerView
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 44, 44)];
    pickerView.backgroundColor = [UIColor colorWithRed:247.0/255.0f green:248.0/255.0f
                                                  blue:247.0/255 alpha:1.0f];
    pickerView.showsSelectionIndicator = YES;
    return pickerView;
}

-(void)doneTouched:(UIBarButtonItem*)sender
{
    [self hideKeyboardAndAdjustTable];
}

@end
