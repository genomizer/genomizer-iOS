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

@implementation AnnotationTableViewController{
    NSMutableArray *sortArray;
}

/**
 * Method that runs when the view controller is loaded.
 * Also adds this viewcontroller to the list of loaded viewcontrollers in AppDelegate.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.editing = true;

    sortArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"sortArray"];
    sortArray = sortArray.mutableCopy;
    if(sortArray == nil){
        sortArray = [[NSMutableArray alloc] init];
        NSArray *annotations = [_describer getVisibleAnnotations];
        for(Annotation *a in annotations){
            [sortArray addObject:[a getFormatedName]];
        }
        [sortArray insertObject:@"Name" atIndex:0];
        [sortArray insertObject:@"Created by" atIndex:1];
    }
    //add self to appDelegate
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nrOfRows = 0;
    if(section == 0){
        nrOfRows = _describer.annotations.count;
    } else if(section == 1){
        nrOfRows = sortArray.count;
    }
    return nrOfRows;
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
    cell.backgroundView = [[UIView alloc] init];
    cell.backgroundView.backgroundColor = [UIColor whiteColor];
    
    if(indexPath.section == 0){
        
        Annotation *annotation = [_describer.annotations objectAtIndex:indexPath.row];
        cell.label.text = [annotation getFormatedName];
        cell.switchButton.tag = indexPath.row;
        cell.switchButton.on = [_describer showsAnnotation: [_describer.annotations objectAtIndex: indexPath.row]];
        cell.switchButton.hidden = false;
        
    } else{
        NSString *annotation = [sortArray objectAtIndex:indexPath.row];
        cell.label.text = annotation;
        cell.switchButton.hidden = true;
    }
    return cell;
}

#define kHeaderHeight 46.f
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderHeight)];
    v.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.f];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectInset(v.bounds, 15, 0)];
    l.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.f];
    [v addSubview:l];
    
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return kHeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = @"Show annotations";
    if (section == 1) {
        title = @"Sort by";
    }
    return title;
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    if (proposedDestinationIndexPath.section == 0) {
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    id object = sortArray[sourceIndexPath.row];
    [sortArray removeObjectAtIndex:sourceIndexPath.row];
    [sortArray insertObject:object atIndex:destinationIndexPath.row];

}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section > 0;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

/**
 * Method that is called when this view will stop being the main view.
 * The method makes its ExperimentDescriber save the current visibility status for annotations
 * to file for later use.
 *
 */
-(void) viewWillDisappear:(BOOL)animated
{
    [_describer saveAnnotationsToFile];
    [[NSUserDefaults standardUserDefaults] setObject:sortArray forKey:@"sortArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
        [sortArray addObject:[annotation getFormatedName]];
    } else {
        [_describer hideAnnotation:annotation];
        [sortArray removeObject:[annotation getFormatedName]];
    }

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

@end
