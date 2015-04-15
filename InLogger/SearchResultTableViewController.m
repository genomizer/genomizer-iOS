//
//  SearchResultTableViewController.m
//  Genomizer
//
//  Class that handles the search result view
//

#import "SearchResultTableViewController.h"
#import "SearchResultTableViewCell.h"
#import "DataFileViewController.h"
#import "AnnotationTableViewController.h"

@interface SearchResultTableViewController ()

@property CGFloat tableCellWidth;

@end

@implementation SearchResultTableViewController

/**
 * Method that runs when the view controller is loaded.
 * It sets the width of the tables in the table view, used to calculate size of cells
 * dynamically.
 * Also adds this viewcontroller to the list of loaded viewcontrollers in AppDelegate.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    SearchResultTableViewCell *cell= [self.tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell"];
    _tableCellWidth = cell.textFieldSize.width;
    
    //add self to appDelegate
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    [app addController:self];
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

/**
 * Method that is called when a new cell is to be shown in the table view.
 * Re-uses an existing cell if possible, otherwise a new cell is generated.
 * It also sets the information in the cell.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Experiment *experiment = [_searchResults objectAtIndex: indexPath.row];
    [cell setTextFieldText: [_experimentDescriber getDescriptionOf: experiment]];

    cell.index = indexPath.row;
    cell.experiement = experiment;
    cell.controller = self;
    return cell;
}

/**
 * Method that calculates the height of the cell according to the size of the text to 
 * be shown in the cell.
 *
 */
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Experiment *experiment = [_searchResults objectAtIndex: indexPath.row];
    NSString *text = [_experimentDescriber getDescriptionOf: experiment];
    UIFont *font = [UIFont systemFontOfSize:14];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(self.tableCellWidth, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                             attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return ceilf(rect.size.height+25);
}

/**
 * Method that is called when a cell in the tableview is clicked. It calls didSelectRow with
 * the appropriate rownumber.
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectRow: indexPath.row];
}

/**
 * Method that sets currently selected experiment to the one described by the cell at
 * row 'row'. It also shows a file list view for the selected experiment.
 *
 */
-(void) didSelectRow: (NSInteger) row
{
    _selectedExperiment = [_searchResults objectAtIndex: row];
    [self performSegueWithIdentifier:@"toFileList1" sender:self];
}

/**
 * Method that is called when the Edit button is pressed in the view.
 * It shows the Edit Annotations view where the user can change which annotations
 * are visible in the search result view.
 *
 */
- (IBAction)editButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"toEditDisplay" sender:self];
}

/**
 * Method which is called when the view is about to appear. Reloads the tableview data
 * to make sure it is up to date.
 *
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

/**
 * Method which is called when a segue is about to be performed.
 * It sends relevant data to the next view controller.
 *
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toFileList1"] || [segue.identifier isEqualToString:@"toFileList2"]) {
        DataFileViewController *nextVC = (DataFileViewController *)[segue destinationViewController];
        nextVC.experiment = _selectedExperiment;
    } else if ([segue.identifier isEqualToString:@"toEditDisplay"]) {
        AnnotationTableViewController *nextVC = (AnnotationTableViewController *)[segue destinationViewController];
        nextVC.describer = _experimentDescriber;
    }
}

/**
 * Used for returning to this view from subviews. Must be here even though it is empty.
 *
 */
- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    
}

@end
