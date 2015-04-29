//
//  AnnotationTableViewController.m
//  Genomizer
//
//  Class that handles the view for showing/hiding annotations in the search result cells.
//  This class uses ExperimentDescriber to handle data storage.
//

#import "AnnotationTableViewController.h"
#import "AnnotationTableViewCell.h"
#import "SearchResultTableViewController.h"
#import "ServerConnection.h"
#import "PopupGenerator.h"
#import "Annotation.h"

@interface AnnotationTableViewController ()

@end

@implementation AnnotationTableViewController

/**
 * Method that runs when the view controller is loaded.
 * Also adds this viewcontroller to the list of loaded viewcontrollers in AppDelegate.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //add self to appDelegate
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_describer.annotations count];
}



/**
 * Method that is called when a new cell is to be shown in the table view.
 * Re-uses an existing cell if possible, otherwise a new cell is generated.
 * It also sets the information in the cell. and sets the switch button of the cell to the
 * current visibility state of each annotation.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnotationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnotationPrototypeCell" forIndexPath:indexPath];
    Annotation *annotation = [_describer.annotations objectAtIndex:indexPath.row];
    cell.label.text = [annotation getFormatedName];
    cell.switchButton.tag = indexPath.row;
    cell.switchButton.on = [_describer showsAnnotation: [_describer.annotations objectAtIndex: indexPath.row]];
    return cell;
}

/**
 * Method that is called when this view will stop being the main view.
 * The method makes its ExperimentDescriber save the current visibility status for annotations
 * to file for later use.
 *
 */
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_describer saveAnnotationsToFile];
}

/**
 * Method that is called when a switch button is switched in the view.
 * The method updates the visibility status of the switched annotation.
 *
 */
- (IBAction)switchButtonValueChanged:(UISwitch *)sender
{
    Annotation *annotation = [_describer.annotations objectAtIndex:sender.tag];

    if (sender.on) {
        [_describer showAnnotation: annotation];
    } else {
        [_describer hideAnnotation:annotation];
    }
}

@end
