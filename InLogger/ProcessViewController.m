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
#import "XYZExperimentFile.h"
@interface ProcessViewController ()

@end

@implementation ProcessViewController

static NSMutableArray * processingExperimentFiles;

+ (void)initialize
{
    if (processingExperimentFiles == nil) {
        processingExperimentFiles = [[NSMutableArray alloc] init];
    }
}

+ (void) addProcessingExperiment:(XYZExperimentFile *) file {

    if(![processingExperimentFiles containsObject:file]){
         [processingExperimentFiles addObject:file];
    }
   
    
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
    cell.file.text = [[processingExperimentFiles objectAtIndex:indexPath.row] name];
    NSLog(@"started : %@", processingExperimentFiles);
    [cell.activityIndicator startAnimating];   
    
    return cell;
}




@end
