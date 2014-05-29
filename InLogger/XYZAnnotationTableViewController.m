//
//  XYZAnnotationTableViewController.m
//  Genomizer
//
//  Class that handles the view for showing/hiding annotations in the search result cells.
//  This class uses XYZExperimentDescriber to handle data storage.
//

#import "XYZAnnotationTableViewController.h"
#import "XYZAnnotationTableViewCell.h"
#import "XYZSearchResultTableViewController.h"
#import "ServerConnection.h"
#import "XYZPopupGenerator.h"
#import "XYZAnnotation.h"
#import "AppDelegate.h"

@interface XYZAnnotationTableViewController ()

@end

@implementation XYZAnnotationTableViewController

/**
 * Method that runs when the view controller is loaded.
 * Also adds this viewcontroller to the list of loaded viewcontrollers in AppDelegate.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //add self to appDelegate
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app addController:self];
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
    XYZAnnotationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnotationPrototypeCell" forIndexPath:indexPath];
    XYZAnnotation *annotation = [_describer.annotations objectAtIndex:indexPath.row];
    cell.label.text = [annotation getFormatedName];
    cell.switchButton.tag = indexPath.row;
    cell.switchButton.on = [_describer showsAnnotation: [_describer.annotations objectAtIndex: indexPath.row]];
    return cell;
}

/**
 * Method that is called when this view will stop being the main view.
 * The method makes its XYZExperimentDescriber save the current visibility status for annotations
 * to file for later use.
 *
 */
-(void) viewWillDisappear:(BOOL)animated
{
    [_describer saveAnnotationsToFile];
}

/**
 * Method that is called when a switch button is switched in the view.
 * The method updates the visibility status of the switched annotation.
 *
 */
- (IBAction)switchButtonValueChanged:(UISwitch *)sender
{
    XYZAnnotation *annotation = [_describer.annotations objectAtIndex:sender.tag];

    if (sender.on) {
        [_describer showAnnotation: annotation];
    } else {
        [_describer hideAnnotation:annotation];
    }
}

@end
