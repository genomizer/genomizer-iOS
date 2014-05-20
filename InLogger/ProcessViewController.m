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

@interface ProcessViewController ()

@end

@implementation ProcessViewController

static NSMutableArray * processingExperimentFiles;

- (void)initialize
{
    if (processingExperimentFiles == nil) {
        processingExperimentFiles = [[NSMutableArray alloc] init];
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    [ServerConnection getProcessStatus:self];
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
    
    cell.file.text = temp.experimentName;
    cell.status.text = temp.status;
    //NSLog(@"started : %@", processingExperimentFiles);
    
    if([temp.status isEqualToString:@"Started"])
    {
        [cell.activityIndicator startAnimating];
        cell.activityIndicator.hidden = NO;
    } else
    {
        cell.activityIndicator.hidden = YES;
    }
    
    return cell;
}

- (void) reportProcessStatusResult: (NSArray*) result error: (NSError*) error {
    
    [self resetProcessingExperimentFiles];
    if(error == nil)
    {
        for(NSDictionary *processStatus in result)
        {
            [self addProcessingExperiment:[[ProcessStatusDescriptor alloc] init: processStatus]];
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    } else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [XYZPopupGenerator showErrorMessage:error];
        });
    }
}

@end