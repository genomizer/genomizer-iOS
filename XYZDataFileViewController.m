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
#import <QuartzCore/QuartzCore.h>

@interface XYZDataFileViewController ()
@property (weak, nonatomic) IBOutlet UIView *infoAboutFile;
@property (weak, nonatomic) IBOutlet UITextView *infoFileTextField;
@property (weak, nonatomic) IBOutlet UIView *dimView;

@property NSMutableArray *cells;
@property NSMutableArray *selectedFiles;

@end

@implementation XYZDataFileViewController

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
    _cells = [[NSMutableArray alloc] initWithCapacity:3];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setExperiment:(XYZExperiment *)experiment
{
    _experiment = experiment;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
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
    NSLog(@"number of rows: %d", [[self arrayFromSection:section] count]);
    return [[self arrayFromSection:section] count];
}


- (NSInteger) rowsBeforeSection: (NSInteger) section
{
    NSInteger rows = 0;
    for (int i = 0; i < section; i++) {
        rows += [[self arrayFromSection:i] count];
    }
    return rows;
}

- (NSArray *) arrayFromSection : (NSInteger)section
{
    switch (section) {
        case 0:
            return _experiment.rawFiles;
        case 1:
            return _experiment.profileFiles;
        case 2:
            return _experiment.regionFiles;
        case 3:
            return _experiment.otherFiles;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYZDataFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataFilePrototypeCell" forIndexPath:indexPath];
    XYZExperimentFile *file = [[self arrayFromSection: indexPath.section] objectAtIndex:indexPath.row];
    cell.textField.text = [file getDescription];
    cell.switchButton.on = NO;
    cell.file = file;
    cell.infoButtonFiles.tag = indexPath.row;
    cell.tag = file.type;
    NSLog(@"section %d row %d", indexPath.section, indexPath.row);
    [_cells setObject:cell atIndexedSubscript:[self rowsBeforeSection:indexPath.section] + indexPath.row];
    
    return cell;
}

- (IBAction)addFilesToSelectedFilesOnTouchUpInside:(UIButton *)sender
{
    //TODO - Send to server.
    BOOL cellOn = false;
    NSLog(@"Raw cells: %d", [_cells count]);
    for (NSInteger i = 0; i < [_cells count]; i++) {
        XYZDataFileTableViewCell *cell = [_cells objectAtIndex:i];
        if (cell.switchButton.on) {
            cellOn = YES;
            [XYZSelectedFilesViewController addExperimentFile: cell.file];
        }
    }
    
    if (cellOn){
        [XYZPopupGenerator showPopupWithMessage:@"Files added to Selected Files."];
    } else {
        [XYZPopupGenerator showPopupWithMessage:@"Please select files to add to Selected Files"];
    }
    
    for (XYZDataFileTableViewCell *cell in _cells) {
        cell.switchButton.on = NO;
    }
}

- (IBAction)convertToProfileOnTouchUpInside:(id)sender
{
    _selectedFiles = [[NSMutableArray alloc] init];
    FileType type = OTHER;
    BOOL asd = NO;
    NSLog(@"Raw cells: %d", [_cells count]);
    for (NSInteger i = 0; i < [_cells count]; i++) {
        XYZDataFileTableViewCell *cell = [_cells objectAtIndex:i];
        if (cell.switchButton.on ) {
            if (!asd || cell.tag == type) {
                type = cell.tag;
                if(type == RAW) {
                    NSMutableDictionary * currentFile = [[NSMutableDictionary alloc] init];
                    [currentFile setObject:cell.file.name forKey:@"filename"];
                    [currentFile setObject:cell.file.idFile forKey:@"fileId"];
                    [currentFile setObject:cell.file.expID forKey:@"expid"];
                    [currentFile setObject:@"rawtoprofile" forKey:@"processtype"];
                    [currentFile setObject:cell.file.metaData forKey:@"metadata"];
                    [currentFile setObject:cell.file.grVersion forKey:@"genomeRelease"];
                     [currentFile setObject:cell.file.author forKey:@"author"];
                    [_selectedFiles addObject:cell.file];
          
                }
            asd = YES;
            } else {
                [XYZPopupGenerator showPopupWithMessage:@"Please select files of same type."];
                return;
            }
        }
     
    }
    
    if ([_selectedFiles count] > 0) {
        [self performSegueWithIdentifier:@"toSelectTask" sender:_selectedFiles];
    } else {
        [XYZPopupGenerator showPopupWithMessage:@"Please select files to convert."];
    }
    for (XYZDataFileTableViewCell *cell in _cells) {
        cell.switchButton.on = NO;
    }
}
- (IBAction)FileInfoButton:(UIButton*)sender {
   
    _dimView.hidden = NO;
    _infoAboutFile.hidden = NO;
    _infoAboutFile.layer.cornerRadius = 5;
    _infoAboutFile.layer.masksToBounds = YES;

    _infoAboutFile.layer.borderWidth = 0.4;
    _infoAboutFile.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _infoFileTextField.text = [[[_cells objectAtIndex:sender.tag] file] getAllInfo];
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
        nextVC.experimentFiles = _selectedFiles;
        nextVC.fileType = [(XYZExperimentFile *)[_selectedFiles objectAtIndex:0] type];

    }
}

- (IBAction) unwindToList:(UIStoryboardSegue *)segue
{
    
}




@end
