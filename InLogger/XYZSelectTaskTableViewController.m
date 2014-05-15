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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSArray *) tasksOfFileType: (FileType) fileType
{
    switch(fileType) {
        case RAW :
            return [[NSArray alloc] initWithObjects:@"Convert to profile", @"Convert to profile with ratio calc.", nil];
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
        if([[sender.superview.subviews[1] valueForKey:@"text"] isEqualToString:@"Convert to profile"]){
            NSLog(@"toConvertToProfile %@", [sender.superview.subviews[1] valueForKey:@"tag"]);
            [self performSegueWithIdentifier:@"toConvertToProfile" sender:_experimentFiles];
        }
        else{
            NSLog(@"executeTaskRatio");
            [self performSegueWithIdentifier:@"executeTaskRatio" sender:_experimentFiles];
        }
    } else {
        [XYZPopupGenerator showPopupWithMessage:@"Not yet implemented!"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toConvertToProfile"]) {
          NSLog(@"prepConvertToProfile");
        RawConvertViewController *nextVC = (RawConvertViewController *)[segue destinationViewController];
        nextVC.experimentFiles = _experimentFiles;
        nextVC.ratio = false;
 
    }
    if ([segue.identifier isEqualToString:@"executeTaskRatio"]) {
      
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

    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadData];
}


@end
