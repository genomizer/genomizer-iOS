//
//  XYZDataFileViewController.m
//  InLogger
//
//  Created by Joel Viklund on 30/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZDataFileViewController.h"
#import "XYZSearchResultTableViewController.h"
#import "XYZExperimentFile.h"
#import "XYZTitleTableViewCell.h"
#import "XYZDataFileTableViewCell.h"
#import "ServerConnection.h"
#import "XYZSelectedFilesViewController.h"
#import "XYZPopupGenerator.h"
#import "XYZSelectTaskTableViewController.h"
#import "XYZFileContainer.h"

@interface XYZDataFileViewController ()

@property (weak, nonatomic) IBOutlet UIView *infoAboutFile;
@property (weak, nonatomic) IBOutlet UITextView *infoFileTextField;
@property (weak, nonatomic) IBOutlet UIView *dimView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XYZDataFileViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _selectedFiles = [[XYZFileContainer alloc] init];
}

- (void)setExperiment:(XYZExperiment *)experiment
{
    _experiment = experiment;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Raw data";
        case 1:
            return @"Profile data";
        case 2:
            return @"Region data";
        case 3:
            return @"Other";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_experiment.files getFiles: section] count];
}


- (NSInteger) rowsBeforeSection: (NSInteger) section
{
    NSInteger rows = 0;
    for (int i = 0; i < section; i++) {
        rows += [[_experiment.files getFiles: i] count];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYZDataFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataFilePrototypeCell" forIndexPath:indexPath];
    XYZExperimentFile *file = [[_experiment.files getFiles: indexPath.section] objectAtIndex:indexPath.row];
    cell.textField.text = [file getDescription];
    cell.switchButton.on = [_selectedFiles containsFile:file];
    cell.file = file;
    cell.controller = self;
    return cell;
}

- (IBAction)addFilesToSelectedFilesOnTouchUpInside:(UIButton *)sender
{
    NSArray *selectedFiles = [_selectedFiles getFiles];
    NSLog(@"%d", [selectedFiles count]);
    for (NSInteger i = [selectedFiles count]; i > 0; i--) {
        XYZExperimentFile *file = [selectedFiles objectAtIndex:i-1];
        [XYZSelectedFilesViewController addExperimentFile: file];
        [_selectedFiles removeExperimentFile:file];
    }
    
    if ([selectedFiles count] > 0){
        [XYZPopupGenerator showPopupWithMessage:@"Files added to Selected Files."];
    } else {
        [XYZPopupGenerator showPopupWithMessage:@"Please select files to add to Selected Files"];
    }
    
    [_tableView reloadData];
}

- (IBAction)convertToProfileOnTouchUpInside:(id)sender
{
    NSArray *selectedFiles = [_selectedFiles getFiles];
    if ([selectedFiles count] == 0) {
        [XYZPopupGenerator showPopupWithMessage:@"Please select files to convert."];
        return;
    } else if([XYZExperimentFile ambigousFileTypes: selectedFiles]) {
        [XYZPopupGenerator showPopupWithMessage:@"Please select files of same type."];
    }
    
    FileType type = ((XYZExperimentFile *)selectedFiles[0]).type;
    if (type == RAW) {
        [self performSegueWithIdentifier:@"toSelectTask" sender:selectedFiles];
    }
}

- (void) showInfoAbout: (XYZExperimentFile *) file
{
    _dimView.hidden = NO;
    _infoAboutFile.hidden = NO;
    _infoAboutFile.layer.cornerRadius = 5;
    _infoAboutFile.layer.masksToBounds = YES;
    
    _infoAboutFile.layer.borderWidth = 0.4;
    _infoAboutFile.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _infoFileTextField.text = [file getAllInfo];
    [[_infoFileTextField layer] setBorderColor : [[UIColor lightGrayColor] CGColor]];
    [[_infoFileTextField layer] setBorderWidth:0.4];
}

- (IBAction)closeFileInfo:(id)sender {
    _infoAboutFile.hidden = YES;
    _dimView.hidden = YES;
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toSelectTask"]) {
        UINavigationController *navController = segue.destinationViewController;
        XYZSelectTaskTableViewController *nextVC = (XYZSelectTaskTableViewController *)(navController.viewControllers[0]);
        nextVC.experimentFiles = sender;
        nextVC.fileType = ((XYZExperimentFile *)sender[0]).type;
    }
}

- (IBAction) unwindToList:(UIStoryboardSegue *)segue
{
    
}

@end
