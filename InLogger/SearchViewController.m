//
//  SearchViewController.m
//  Genomizer
//
// Class that controlls the SearchView. the searchView shows a list of annotations
// the user is avaliable to search for to retrive an experiment. The annotations is
// recived from the server. when the a search button is pressed a request to find
// experiments matching the searchvalues are sent to the server.
//

#import "SearchViewController.h"
#import "SearchResultTableViewController.h"
#import "ServerConnection.h"
#import "PopupGenerator.h"
#import "SearchTableViewCell.h"
#import "Annotation.h"
#import "PubMedBuilder.h"
#import "AppDelegate.h"

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *advancedView;
@property (weak, nonatomic) IBOutlet UITextView *pubmedTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property bool searching;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _spinner.hidesWhenStopped = YES;
    //add self to appDelegate
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app addController:self];
    NSLog(@"SearchViewController didLoad");
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

/**
 * This method is called by serverConnection.m after serverConnection
 * has executed a getAvailableAnnotations. If a error occured a popup with information
 * about the error will be shown to the user.
 *
 * @param result - Contains all annotations that was sent back from the server.
 * @param error - If a error occured this variable will be set.
 * @return stores all annotations in the NSArray annotations.
 */
- (void) reportAnnotationResult: (NSArray*) result error: (NSError*) error {
    dispatch_async(dispatch_get_main_queue(), ^{
    if(error == nil)
    {
        
        [self annotationsIsFinishedWithResult: result];
        
    } else
    {
        [PopupGenerator showErrorMessage:error];
        [self annotationsIsFinishedWithResult: nil];
        
    }
    });
}

- (void)scrollToCell: (UITableViewCell *) cell
{
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 117, 0);
    [_tableView scrollToRowAtIndexPath:[_tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Returns number of sections in the tableView.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Returns number of rows in the tableView.
    return [_annotations count];
}

/**
 * This method sets up the tableview.
 * Creates a cell and puts data into it.
 * @param tableView - the tableview.
 * @param cellForRowAtIndexPath - what index in the tableView the
 *                                created cell will be added to.
 * @return a cell that will be added to the tableView.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Annotation *annotation = [_annotations objectAtIndex:indexPath.row];
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
/**
 * Method that will be called when the search button is pressed.
 *
 * @return The search data that was entered by the user is sent to
 *         serverConnections search method.
 */
- (IBAction)searchButton:(id)sender {
    [self searchIsStarting];
    NSArray *selectedAnnotations = [self getSelectedAnnotations];
    [ServerConnection search:[PubMedBuilder createAnnotationsSearch: selectedAnnotations] withContext:self];
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

/*
 * Executes when a getAnnotations requrest from server is called.
 */
- (void) annotationsIsStarting
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _searchButton.enabled = NO;
}

/*
 * Executes when a search request from server is finished.
 */
- (void) searchIsFinished
{
    [_spinner stopAnimating];
    _searchButton.enabled = YES;
    _searchButton.hidden = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    _searching = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/*
 * Executes when a search request from server is called.
 */
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

/**
 * This method is called by serverConnection.m after serverConnection
 * has executed a search. If a error occured a popup with information
 * about the error will be shown to the user.
 *
 * @param result - the searchResults.
 * @param error - If a error occured this variable will be set.
 * @return preforms a segue to searchResults.
 */
- (void) reportSearchResult: (NSMutableArray*) result error: (NSError*) error
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    if(!app.userIsLoggingOut)
    {
        if(error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self searchIsFinished];
                [PopupGenerator showErrorMessage:error];
            });
        } else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self searchIsFinished];
                [self performSegueWithIdentifier:@"searchResult" sender:result];
            });
        }
    } else{
    }
}

/**
 * Method that returns all annotations selected by the user.
 *
 * @return A array containing all selected annotations.
 */
- (NSArray *) getSelectedAnnotations
{
    NSMutableArray *selectedAnnotations = [[NSMutableArray alloc] init];
    for (Annotation *annotation in _annotations) {
        if (annotation.selected) {
            [selectedAnnotations addObject:annotation];
        }
    }
    return selectedAnnotations;
}
/**
 * Method that executes when the "close"-button in the advanced
 * search frame is pressed.
 */
- (IBAction)closeAdvancedSearch:(id)sender {
    _advancedView.hidden = YES;
    _tableView.userInteractionEnabled = YES;
    [_pubmedTextView endEditing:YES];
}

/**
 * Method that executes when the "search"-button is pressed.
 */
- (IBAction)searchQueryButtonTouched:(id)sender {
    [self searchIsStarting];
    
    //send search
    [ServerConnection search:_pubmedTextView.text withContext:self];
    _advancedView.hidden = YES;
    _tableView.userInteractionEnabled = YES;
    [_pubmedTextView endEditing:YES];
}

/**
 * Method that executes when the "search"-button in the advanced
 * search frame is pressed.
 */
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
    _pubmedTextView.text = [PubMedBuilder createAnnotationsSearch: selectedAnnotations];
    [_pubmedTextView becomeFirstResponder];
}
/**
 * Method that executes before a segue is done.
 *
 * @return stores the results of a serarch in the "searchResult" controller.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchResult"]) {
        SearchResultTableViewController *nextVC = (SearchResultTableViewController *)[segue destinationViewController];
        nextVC.searchResults = sender;
        nextVC.experimentDescriber = [[ExperimentDescriber alloc] initWithAnnotations: _annotations];
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
/**
 * Method that adds a "done"-button to the pickerview for
 * annotations that have specified values.
 *
 * @return the done button that is added to the pickerview.
 */
- (UIToolbar *) createPickerViewToolBar: (UIPickerView *) pickerView
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, pickerView.bounds.size.width, 44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    [toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    return toolBar;
}
/**
 * Method that creates a pickerivew that is shown when a
 * annotation have specified values
 *
 * @return the pickerView.
 */
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
