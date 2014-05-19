//
//  XYZAnnotationTableViewController.m
//  InLogger
//
//  Created by Joel Viklund on 06/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZAnnotationTableViewController.h"
#import "XYZAnnotationTableViewCell.h"
#import "XYZSearchResultTableViewController.h"
#import "ServerConnection.h"
#import "XYZPopupGenerator.h"
#import "XYZAnnotation.h"

@interface XYZAnnotationTableViewController ()

@end

@implementation XYZAnnotationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   // _annotations = [self getAnnotationsFromServer];
}

/*
- (NSArray *) getAnnotationsFromServer
{
    NSError *error;
    NSArray *annotations = [ServerConnection getAvailableAnnotations:&error];
    if (error) {
        [XYZPopupGenerator showErrorMessage:error];
        return [[NSArray alloc] init];
    }
    return annotations;
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_describer.annotations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYZAnnotationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnotationPrototypeCell" forIndexPath:indexPath];
    XYZAnnotation *annotation = [_describer.annotations objectAtIndex:indexPath.row];
    cell.label.text = [annotation getFormatedName];
    cell.switchButton.tag = indexPath.row;
    cell.switchButton.on = [_describer showsAnnotation: [_describer.annotations objectAtIndex: indexPath.row]];
    return cell;
}

- (IBAction)switchButtonValueChanged:(UISwitch *)sender
{
    XYZAnnotation *annotation = [_describer.annotations objectAtIndex:sender.tag];

    if (sender.on) {
        [_describer showAnnotation: annotation];
    } else {
        [_describer hideAnnotation:annotation];
    }
}

@end
