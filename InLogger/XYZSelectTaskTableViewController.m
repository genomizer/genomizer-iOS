//
//  XYZSelectTaskTableViewController.m
//  Genomizer
//
//  Class that lets the user select what type of fileConvert
//  the user want to pereform.
//

#import "XYZSelectTaskTableViewController.h"
#import "RawConvertViewController.h"
#import "XYZPopupGenerator.h"
#import "AppDelegate.h"

@interface XYZSelectTaskTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *executeButton;

@property NSArray *tasks;

@end

@implementation XYZSelectTaskTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tasks = [self tasksOfFileType:_fileType];
    
    //add self to appDelegate
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app addController:self];
}

/**
 * Depending of what filetype the files the user want to convert is, diffrent
 * TableData will show.
 * @return tableData corresponding to filetype of files the user want to convert.
 */
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Returns number of sections in tableView.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Returns number of rows in tableView.
    return [_tasks count];
}

/**
 * Method that executes when a cell in the tableView is pressed.
 * Depending on filetype diffrent things happen. However as of now
 * only rawConvert is implemented.
 * @return calls method prepereForSegue with the files that the user want
 *         to convert.
 */
- (IBAction)touchUpInsideCell:(UIButton *)sender
{
    if (_fileType == RAW) {
        if([[sender.superview.subviews[1] valueForKey:@"text"] isEqualToString:@"Convert to profile"]){
            [self performSegueWithIdentifier:@"toConvertToProfile" sender:_experimentFiles];
        }
        else{
            [self performSegueWithIdentifier:@"executeTaskRatio" sender:_experimentFiles];
        }
    } else {
        [XYZPopupGenerator showPopupWithMessage:@"Not yet implemented!"];
    }
}

/**
 * Method that stores files the user wants to convert in the next viewController
 * (RawConvertViewController).
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toConvertToProfile"]) {
        RawConvertViewController *nextVC = (RawConvertViewController *)[segue destinationViewController];
        nextVC.experimentFiles = _experimentFiles;
        nextVC.ratio = true;
 
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"SelectTaskCellPrototype" forIndexPath:indexPath];
    
    cell.textLabel.text = [_tasks objectAtIndex:indexPath.row];
    cell.textLabel.tag = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadData];
}


@end
