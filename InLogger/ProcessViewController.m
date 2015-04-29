//
//  ProcessViewController.m
//  Genomizer
//
//  Class that controlls the processView, the processView shows information
//  about all processes that the server have either completed,
//  started, waiting or processes that have crashed.
//  Each tableViewCell contains information about one process.
//

#import "ProcessViewController.h"
#import "ProcessTableViewCell.h"
#import "RawConvertViewController.h"
#import "ServerConnection.h"
#import "PopupGenerator.h"
#import "ProcessStatusDescriptor.h"
//#import "AppDelegate.h"
#import "TabViewController.h"
#import "AlertWindow.h"

@interface ProcessViewController (){
//    NSMutableArray *indexUnderMinute;
}
@property UIRefreshControl *refreshControl;
@end

@implementation ProcessViewController

static NSMutableArray * processingExperimentFiles;

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateProcessStatusFromServer];
}

- (void)initialize
{
    if (processingExperimentFiles == nil) {
        processingExperimentFiles = [[NSMutableArray alloc] init];
    }
}

/**
 * Method that calls serverConnection to update the tableView of processes.
 */
- (void) updateProcessStatusFromServer
{

//Pål did this
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    if ([app threadIsAvailable]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [ServerConnection getProcessStatus:^(NSMutableArray *array, NSError *error) {
            [self reportProcessStatusResult:array error:error];
        }];
//    }
}
/**
 * Method that adds a single process to a list containg all processes,
 * but only if that process not already exists in the list of all processes.
 */
- (void) addProcessingExperiment:(ProcessStatusDescriptor *) file {
    
    if(![processingExperimentFiles containsObject:file]){
        [processingExperimentFiles addObject:file];
    }
}

- (void) resetProcessingExperimentFiles
{
    [processingExperimentFiles removeAllObjects];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    //add self to appDelegate
//Pål did this
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    [app addController:self];
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0];
//    indexUnderMinute = [[NSMutableArray alloc] init];
    // Pull tableview down to refresh.
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:_refreshControl];

}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)reloadDatas {
    [self updateProcessStatusFromServer];
    [_refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Returns number of rows in the tableView.
    return processingExperimentFiles.count;
}

/**
 * This method sets up the tableview.
 *
 * @param tableView - the tableview.
 * @param cellForRowAtIndexPath - what index in the tableView the 
 *                                created cell will be added to.
 * @return a cell that will be added to the tableView.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProcessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"processCell2" forIndexPath:indexPath];
    ProcessStatusDescriptor *temp = [processingExperimentFiles objectAtIndex:indexPath.row];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSMutableAttributedString * expAndFile = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ - %@", temp.experimentName, temp.author]];
    [expAndFile addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:cell.file.font.pointSize] range:NSMakeRange(0, temp.experimentName.length)];
    
    
    NSString *added = [NSString stringWithFormat:@"Added %@.", [self dateDiff:temp.timeAdded indexPath:indexPath]];
    NSString *started = [NSString stringWithFormat:@"Started %@.", [self dateDiff:temp.timeStarted indexPath:indexPath]];
    
    cell.file.attributedText = expAndFile;
    cell.status.text = temp.status;
    cell.status.textColor = [temp.status isEqualToString:@"Crashed"] ? [AlertWindow colorForType:@"error"] : cell.status.textColor;
    cell.process.text = [NSString stringWithFormat:@"%@ %@", added, started];
//    cell.file.text = temp.experimentName;
//    cell.status.text = temp.status;
//    cell.added.text =  [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:temp.timeAdded]];
//    cell.started.text = @"Not started";
//    cell.finished.text = @"Not finished";
//    if([temp.status isEqualToString:@"Started"])
//    {
//        cell.started.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:temp.timeStarted]];
//        [cell.activityIndicator startAnimating];
//        cell.activityIndicator.hidden = NO;
//    } else
//    {
//        cell.activityIndicator.hidden = YES;
//    }
//    if([temp.status isEqualToString:@"Finished"])
//    {
//        cell.started.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:temp.timeStarted]];
//        cell.finished.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:temp.timeFinished]];
//    }
//    if([temp.status isEqualToString:@"Crashed"])
//    {
//        cell.started.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:temp.timeStarted]];
//    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(void)sortProcesses{
    [processingExperimentFiles sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ProcessStatusDescriptor *p1 = (ProcessStatusDescriptor *)obj1;
        ProcessStatusDescriptor *p2 = (ProcessStatusDescriptor *)obj2;
        return [p2.timeAdded compare:p1.timeAdded];
    }];
}
/**
 * This method is called by serverConnection.m after serverConnection
 * has executed a getProcessStatus. If a error occured a popup with information
 * about the error will be shown to the user.
 *
 * @param result - Contains all ongoing/finished/crashed processes on the server.
 * @param error - If a error occured this variable will be set.
 * @return adds all processes to the NSMutableArray processingExperimentFiles.
 */
- (void) reportProcessStatusResult: (NSMutableArray*) result error: (NSError*) error {
    
    [self resetProcessingExperimentFiles];
    if(error == nil){
        for(NSDictionary *processStatus in result){
            [self addProcessingExperiment:[[ProcessStatusDescriptor alloc] init: processStatus]];
        }
    
        [self sortProcesses];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
            
//Pål did this
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            AppDelegate *app = [UIApplication sharedApplication].delegate;
//            [app threadFinished];
        });
    } else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString * errorMsg = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
            [(TabBar2Controller *)self.tabBar2Controller showPopDownWithTitle:error.domain andMessage:errorMsg type:@"error"];
            
            
//Pål did this
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            AppDelegate *app = [UIApplication sharedApplication].delegate;
//            [app threadFinished];
        });
    }
}

-(NSString *)dateDiff:(NSDate *)convertedDate indexPath:(NSIndexPath *)indexPath{
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];

    ti = ti * -1;
    if(ti < 1) {
        return @"never";
    } else 	if (ti < 60) {
        return [NSString stringWithFormat:@"%.0fs ago", ti];
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%dm ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%dh ago", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%dd ago", diff];
    } else {
        return @"never";
    }	
}
//
//-(void)reloadIndexPath:(NSIndexPath *)indexPath{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        if([indexUnderMinute containsObject:indexPath]){
//            [indexUnderMinute removeObject:indexPath];
//        }
//    });
//}

@end
