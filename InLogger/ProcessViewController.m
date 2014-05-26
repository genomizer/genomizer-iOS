//
//  ProcessViewController.m
//  Genomizer
//
//  Created by Linus Öberg on 15/05/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import "ProcessViewController.h"
#import "ProcessTableViewCell.h"
#import "RawConvertViewController.h"
#import "ServerConnection.h"
#import "XYZPopupGenerator.h"
#import "ProcessStatusDescriptor.h"
#import "AppDelegate.h"

@interface ProcessViewController ()
@property  NSTimer *timer;
@end

@implementation ProcessViewController

static NSMutableArray * processingExperimentFiles;

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"appear");
    
    [self updateProcessStatusFromServer];
}

- (void)initialize
{
    if (processingExperimentFiles == nil) {
        processingExperimentFiles = [[NSMutableArray alloc] init];
    }
}

- (void) updateProcessStatusFromServer
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if([app threadIsAvailable])
    {
        [ServerConnection getProcessStatus:self];
    }
}

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
    [ServerConnection getProcessStatus:self];
   
    //add self to appDelegate
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app addController:self];
    //[self updateProcessStatusFromServer];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateProcessStatusFromServer)];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

-(void) timerDidTick:(NSTimer*) theTimer{
    NSLog(@"timer ");
    [self updateProcessStatusFromServer];
    
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
    return processingExperimentFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProcessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"processCell" forIndexPath:indexPath];
    ProcessStatusDescriptor *temp = [processingExperimentFiles objectAtIndex:indexPath.row];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    cell.file.text = temp.experimentName;
    cell.status.text = temp.status;
    cell.added.text =  [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:temp.timeAdded]];
    cell.started.text = @"Not started";
    cell.finished.text = @"Not finished";
    if([temp.status isEqualToString:@"Started"])
    {
        cell.started.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:temp.timeStarted]];
        [cell.activityIndicator startAnimating];
        cell.activityIndicator.hidden = NO;
    } else
    {
        cell.activityIndicator.hidden = YES;
    }
    if([temp.status isEqualToString:@"Finished"])
    {
        cell.started.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:temp.timeStarted]];
        cell.finished.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:temp.timeFinished]];
    }
    if([temp.status isEqualToString:@"Crashed"])
    {
        cell.started.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:temp.timeStarted]];
    }
    return cell;
}

- (void) reportProcessStatusResult: (NSMutableArray*) result error: (NSError*) error {
    
    [self resetProcessingExperimentFiles];
    if(error == nil)
    {
        for(NSDictionary *processStatus in result)
        {
            [self addProcessingExperiment:[[ProcessStatusDescriptor alloc] init: processStatus]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            [app threadFinished];
        });
    } else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XYZPopupGenerator showErrorMessage:error];
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            [app threadFinished];
        });
    }
}

@end
