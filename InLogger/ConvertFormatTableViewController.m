//
//  ConvertFormatTableViewController.m
//  Genomizer
//
//  Created by Mattias Scherer on 04/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import "ConvertFormatTableViewController.h"
#import "ConvertFormatTableViewCell.h"

@interface ConvertFormatTableViewController ()
    



@property (nonatomic, strong) NSString *selectedFormat;
@property (nonatomic, strong) NSArray *possibleFormats;
@property (nonatomic, strong) NSIndexPath *pickerViewIndexPath;

@end

@implementation ConvertFormatTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *convertButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Convert"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(convert)];
    self.navigationItem.rightBarButtonItem = convertButton;
    
    self.title = @"Convert file format";
    self.possibleFormats = @[@"format1", @"format2", @"format3"];
    self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _container = [[NSMutableArray alloc] init];
    
    for (ExperimentFile *file in self.files) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:file,@"value", self.possibleFormats[0], @"format", nil];
        
        [self.container addObject:dict];
    }
    
}

- (void)convert
{
    NSLog(@"Convert!!!");
    // use self.container to get dictionary with files and format to convert to.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedFormat = [self.possibleFormats objectAtIndex:row];
    NSIndexPath *parentIndexPath = [NSIndexPath indexPathForRow:(self.pickerViewIndexPath.row-1) inSection:0];
    ConvertFormatTableViewCell *cell = (ConvertFormatTableViewCell *)[self.tableView cellForRowAtIndexPath:parentIndexPath];
    cell.format.text = self.selectedFormat;
    NSMutableDictionary *fileInfo = [self.container objectAtIndex:parentIndexPath.row];
    [fileInfo setObject:self.selectedFormat forKey:@"format"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.possibleFormats.count;
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.possibleFormats[row];
}

- (BOOL)pickerViewIsShown {
    return self.pickerViewIndexPath != nil;
}

- (void)hideExistingPicker {
    NSIndexPath *temp = self.pickerViewIndexPath;
    self.pickerViewIndexPath = nil;
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:temp.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    
}

- (NSIndexPath *)calculateIndexPathForNewPicker:(NSIndexPath *)selectedIndexPath {
    NSIndexPath *newIndexPath;
    
    if (([self pickerViewIsShown]) && (self.pickerViewIndexPath.row < selectedIndexPath.row)){
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row - 1 inSection:0];
        
    }else {
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row  inSection:0];
        
    }
    
    return newIndexPath;
}

- (void)showNewPickerAtIndex:(NSIndexPath *)indexPath {
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];

}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger numberOfRows = self.container.count;
    if ([self pickerViewIsShown]) {
        numberOfRows++;
    }
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    
    
    if ([self pickerViewIsShown] && (self.pickerViewIndexPath.row == indexPath.row))
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"picker"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"picker"];
        
            UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 200.0f)];
            pickerView.delegate = self;
            pickerView.dataSource = self;
            
            // TODO set picker row by what the default format for converting the file.
            [pickerView setTag:1];
            [cell addSubview:pickerView];
            
            UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(250.0f, 5.0f, 60.0f, 30.0f)];
            [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [doneBtn addTarget:self action:@selector(doneBtnTap:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:doneBtn];
        }
        
        return cell;
    } else {
        NSMutableDictionary *rowInfo;
        if ([self pickerViewIsShown] && indexPath.row > self.pickerViewIndexPath.row) {
            rowInfo = [self.container objectAtIndex:indexPath.row-1];

        } else {
            rowInfo = [self.container objectAtIndex:indexPath.row];

        }
        ConvertFormatTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"format cell"];
        
        if (cell == nil)
        {
            cell = [[ConvertFormatTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"format cell"];
        }
        ExperimentFile *file = [rowInfo objectForKey:@"value"];
        cell.fileName.text = file.name;
        cell.format.text = @"format1";
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!([self pickerViewIsShown] && (self.pickerViewIndexPath.row == indexPath.row)))
    {
        return 44.0f;
    }
    else
    {
        return 200.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self pickerViewIsShown] && (self.pickerViewIndexPath.row - 1 == indexPath.row)){
        
        [self hideExistingPicker];
        
    } else {
        
        NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewPicker:indexPath];
        
        if ([self pickerViewIsShown]){
            
            [self hideExistingPicker];
            
        }
        self.pickerViewIndexPath = [NSIndexPath indexPathForRow:newPickerIndexPath.row + 1 inSection:0];
        [self showNewPickerAtIndex:newPickerIndexPath];
        
        
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)updateWantedFileFormat:(NSIndexPath *)indexPath
{
    
}

/*!
 @discussion Remove pickerView when done is tapped.
 @param sender The sender
 @return
 */
- (void)doneBtnTap:(id)sender
{
    [self hideExistingPicker];
}


@end
