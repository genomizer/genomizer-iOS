//
//  ConvertFormatTableViewController.m
//  Genomizer
//
//  Created by Mattias Scherer on 04/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import "ConvertFormatTableViewController.h"

@interface ConvertFormatTableViewController () {
    NSIndexPath *pickerViewIsAtRow;
}

@property (nonatomic, strong) NSMutableArray *container;
@property (nonatomic, strong) NSString *selectedFormat;
@property (nonatomic, strong) NSArray *possibleFormats;

@end

@implementation ConvertFormatTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Convert file format";
    self.possibleFormats = @[@"format1", @"format2", @"format3"];
    self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _container = [[NSMutableArray alloc] init];
    
    for (ExperimentFile *file in self.files) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:file,@"value", @"1", @"type", self.possibleFormats[0],
            @"format", nil];
        
        [self.container addObject:dict];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedFormat = [self.possibleFormats objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.possibleFormats.count;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.possibleFormats[row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.container.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSMutableDictionary *rowInfo = [self.container objectAtIndex:indexPath.row];
    
    
    if ([[rowInfo objectForKey:@"type"] intValue] == 1)
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"row"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"row"];
        }
        ExperimentFile *file = [rowInfo objectForKey:@"value"];
        [cell.textLabel setText:file.name];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        return cell;
    } else {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"picker"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"picker"];
            
            UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 200.0f)];
            pickerView.delegate = self;
            pickerView.dataSource = self;
            [pickerView setTag:1];
            [cell addSubview:pickerView];
            
            UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(250.0f, 5.0f, 60.0f, 30.0f)];
            [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
            [doneBtn addTarget:self action:@selector(doneBtnTap:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:doneBtn];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *rowInfo = [self.container objectAtIndex:indexPath.row];
    
    if ([[rowInfo objectForKey:@"type"] intValue] == 1)
    {
        return 44.0f;
    }
    else
    {
        return 200.0f;
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row %d selected", indexPath.row);
    
    
    NSMutableDictionary *rowInfo = [self.container objectAtIndex:indexPath.row];
    
    if ([[rowInfo objectForKey:@"type"] intValue] == 1)
    {
        
        NSMutableDictionary *rowInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2",@"type",nil];
        [self.container insertObject:rowInfo atIndex:indexPath.row+1];
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:nextIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // if there already was a visible pickerview, remove it.
        if (self.isPickerVisible)
        {
            [self.container removeObjectAtIndex:pickerViewIsAtRow.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:pickerViewIsAtRow] withRowAnimation:UITableViewRowAnimationAutomatic];
            self.isPickerVisible = NO;
        }
        pickerViewIsAtRow = nextIndexPath;
        self.isPickerVisible = YES;
    }
}

/*!
 @discussion Remove pickerView when done is tapped.
 @param sender The sender
 @return
 */
- (void)doneBtnTap:(id)sender
{
    UIButton *doneBtn = (UIButton*) sender;
    UITableViewCell *cell = (UITableViewCell*) [doneBtn superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row-1) inSection:0] animated:YES];
    //TODO store selectedFormat with the file somewhere.
    
    // remove picker cell
    [self.container removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.isPickerVisible = NO;
}


@end
