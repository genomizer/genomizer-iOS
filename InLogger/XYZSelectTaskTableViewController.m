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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tasks count];
}

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
