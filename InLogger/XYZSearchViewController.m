//
//  XYZSearchViewController.m
//  InLogger
//
//  Created by Joel Viklund on 25/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSearchViewController.h"
#import "XYZSearchTableViewCell.h"

@interface XYZSearchViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *searchFields;
@property NSMutableDictionary *searchValues;

@end

@implementation XYZSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchFields = [self createSearchFields ];
    [self.tableView reloadData];
    self.searchValues = [NSMutableDictionary dictionary];
    
}

- (NSMutableArray *) createSearchFields
{
    return [NSMutableArray arrayWithObjects:@"Experiment ID", @"Publication ID" , @"Type of data", @"Species", @"Genom release", @"Cell-line", @"Developmental stage", @"Sex", @"Tissue", @"Processing", @"Asd", nil];
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
    return [self.searchFields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    XYZSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *annotation = [self.searchFields objectAtIndex:indexPath.row];
    cell.inputField.placeholder = annotation;
    cell.inputField.tag = indexPath.row;
    cell.switchButton.enabled = true;
    cell.switchButton.on = false;
    cell.switchButton.tag = indexPath.row;
    [cell.switchButton addTarget:self action:@selector(switched:) forControlEvents:UIControlEventValueChanged];
    cell.inputField.delegate = self;
    return cell;
}
- (IBAction)searchButton:(id)sender {
    
 NSLog(@"text %@", self.searchValues);
      [self performSegueWithIdentifier:@"searchResult" sender:self];
  
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    NSLog(@"ASDASDASD");

    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];

    return NO;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if(textField.text.length > 0){
        [self.searchValues setObject:textField.text forKey:textField.placeholder];
        
    }
    else {
        [self.searchValues removeObjectForKey:textField.placeholder];
    }
}
- (void) switched: (id) sender {
    UISwitch * switchy = (UISwitch *) sender;
    if(switchy.on) {
        NSLog(@"text %ld", (long)switchy);
    }
}

- (IBAction)touchUpInsideSwitch:(id)sender {
    [self.view endEditing:YES];
}



@end
