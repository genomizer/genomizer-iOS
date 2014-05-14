//
//  XYZSelectTaskTableViewController.m
//  InLogger
//
//  Created by Joel Viklund on 08/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSelectTaskTableViewController.h"
#import "RawConvertViewController.h"
#import "XYZPopupGenerator.h"

@interface XYZSelectTaskTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *executeButton;
@property NSArray *tasks;
@property NSInteger selectedCellRow;

@end

@implementation XYZSelectTaskTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"loaded");
    _tasks = [self tasksOfFileType:_fileType];
   // NSLog(@"expfile%@", _experimentFiles[0]);
    _selectedCellRow = -1;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSArray *) tasksOfFileType: (FileType) fileType
{
    switch(fileType) {
        case RAW :
            return [[NSArray alloc] initWithObjects:@"Convert to profile", nil];
        case PROFILE:
            return [[NSArray alloc] initWithObjects:@"Convert to region", @"Change genome release", nil];
        case REGION:
            return [[NSArray alloc] initWithObjects:@"Change genome release", nil];
        case OTHER:
            return [[NSArray alloc] initWithObjects: nil];

    }
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
    return [_tasks count];
}

- (IBAction)touchUpInsideCell:(UIButton *)sender
{
    if (_fileType == RAW) {
        [self performSegueWithIdentifier:@"toConvertToProfile" sender:_experimentFiles];
    } else {
        [XYZPopupGenerator showPopupWithMessage:@"Not yet implemented!"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toConvertToProfile"]) {
        RawConvertViewController *nextVC = (RawConvertViewController *)[segue destinationViewController];
        nextVC.experimentFiles = _experimentFiles;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"SelectTaskCellPrototype" forIndexPath:indexPath];
    cell.textLabel.text = [_tasks objectAtIndex:indexPath.row];
    if (_selectedCellRow == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _selectedCellRow = indexPath.row;
    _executeButton.enabled = YES;
    [tableView reloadData];
}


/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    XYZToDoItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
    tappedItem.completed = !tappedItem.completed;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
