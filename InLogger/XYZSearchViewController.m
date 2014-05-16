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

@interface XYZSearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *advancedView;
@property (weak, nonatomic) IBOutlet UITextView *pubmedTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation XYZSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _spinner.hidesWhenStopped = YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [ServerConnection getAvailableAnnotations:self];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_spinner stopAnimating];
    _searchButton.enabled = YES;
    _searchButton.hidden = NO;
}

- (void) reportAnnotationResult: (NSArray*) result error: (NSError*) error {
    
    if(error == nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _annotations = result;
            [self.tableView reloadData];
        });
    } else
    {
     [XYZPopupGenerator showErrorMessage:error];
    }
}

/*
- (NSArray *) getAnnotationsFromServer
{
    NSError *error;
    NSArray *annotations = [ServerConnection getAvailableAnnotations:&error];
   
    if(error) {
        [XYZPopupGenerator showPopupWithMessage:@"Server did not return list of annotations"];
        return [[NSArray alloc] init];
    }
    
    return annotations;
}
 */

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
    XYZAnnotation *annotation = [_annotations objectAtIndex: indexPath.row];
    cell.inputField.placeholder = [annotation getFormatedName];
    cell.inputField.text = annotation.value;
    cell.switchButton.on = annotation.selected;
    cell.controller = self;
    cell.tag = indexPath.row;
    cell.annotation = annotation;
    return cell;
}

- (IBAction)searchButton:(id)sender {
    _spinner.hidden = NO;
    [_spinner startAnimating];
    _searchButton.enabled = NO;
    _searchButton.hidden = YES;
    NSArray *selectedAnnotations = [self getSelectedAnnotations];
    [ServerConnection search:[XYZPubMedBuilder createAnnotationsSearch: selectedAnnotations] withContext:self];
}

- (void) reportSearchResult: (NSMutableArray*) result withParsingError: (NSError*) error
{
    if(error) {
        [XYZPopupGenerator showErrorMessage:error];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_spinner stopAnimating];
            [self performSegueWithIdentifier:@"searchResult" sender:result];
        });
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
    [ServerConnection search:_pubmedTextView.text withContext:self];
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
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [ServerConnection search:_pubmedTextView.text withContext:self];
        return NO;
    }
    return YES;
}

- (void)hideKeyboardAndAdjustTable {
    [self.view endEditing:YES];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_tableView reloadData];
}

@end
