//
//  SelectTaskTableViewController.m
//  Genomizer
//
//  Class that lets the user select what type of fileConvert
//  the user want to pereform.
//

#import "SelectTaskTableViewController.h"
#import "RawConvertViewController.h"
#import "PopupGenerator.h"

@interface SelectTaskTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *executeButton;

@property NSArray *tasks;

@end

@implementation SelectTaskTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tasks = [self tasksOfFileType:_fileType];

}

/**
 * Depending of what filetype the files the user want to convert is, diffrent
 * TableData will show.
 * @param The filetype of the files that are supposed to be converted.
 * @return tableData corresponding to filetype of files the user want to convert.
 */
- (NSArray *) tasksOfFileType: (FileType) fileType
{
    switch(fileType) {
        case RAW :
            return @[@"Convert to profile"];
        case PROFILE:
            return @[@"Convert to region", @"Change genome release"];
        case REGION:
            return @[@"Change genome release"];
        case OTHER:
            return @[];

    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tasks.count;
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
        [PopupGenerator showPopupWithMessage:@"Not yet implemented!"];
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
