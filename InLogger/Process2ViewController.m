//
//  Process2ViewController.m
//  Genomizer
//
//  Created by Erik Berggren on 25/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import "Process2ViewController.h"
#import "ServerConnection.h"

@interface Process2ViewController (){
    NSMutableArray *contentArray;
    NSArray *processTypes;
}

@end

@implementation Process2ViewController

@synthesize tableView, filesToProcess;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    contentArray = [[NSMutableArray alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    NSLog(@"files: %@", filesToProcess);
    
    
    processTypes = @[@{@"type":@"bowtie", @"file_ext":@"wig", @"default_param":@"hejsan"},
                     @{@"type":@"smoothie", @"file_ext":@"smth", @"default_param":@"strawberry+mango"},
                     @{@"type":@"step size", @"file_ext":@"stsz", @"default_param":@"50m"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)sendProcessRequest:(id)sender{
    if(filesToProcess.count == 0){
        [self.tabBar2Controller showPopDownWithTitle:@"No files selected" andMessage:@"Please back one step and add some files." type:@"error"];
        return;
    } else if(contentArray.count == 0){
        [self.tabBar2Controller showPopDownWithTitle:@"No processes" andMessage:@"Tap the Add Process button and add some." type:@"error"];
        return;
    }
    ExperimentFile *firstFile = filesToProcess.firstObject;
    
    NSDictionary *dict = @{@"expId":firstFile.expID, @"processCommands":contentArray};
    [ServerConnection convert:dict withContext:^(NSError *errold, NSString *expId) {
        NSLog(@"Convert sent: %@ %@", expId, errold.localizedDescription);
        if(errold != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tabBar2Controller showPopDownWithError:errold];
            });
        }
    }];
    
     NSData *d = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSDictionary *d1 = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
    NSLog(@"JSON: %@", d1);

}


#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return contentArray.count + 1;
}

-(NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section{
    int nrOfRows = 0;
    if(section == [self numberOfSectionsInTableView:_tableView]-1){
        nrOfRows = 1;
    } else{
        if(contentArray.count >= section && [contentArray[section] isKindOfClass:[NSDictionary class]]){
            NSDictionary *d = contentArray[section];
            nrOfRows = [(NSArray *)d[@"files"] count];
        }
    }
    return nrOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(indexPath.section == [self numberOfSectionsInTableView:_tableView]-1){
        cell = [_tableView dequeueReusableCellWithIdentifier:@"bottomCell"];
        
    } else{
        cell = [_tableView dequeueReusableCellWithIdentifier:@"processCell"];
        Process2Cell *cell2 = (Process2Cell *)cell;
        NSDictionary *file = contentArray[indexPath.section][@"files"][indexPath.row];

        cell2.inFileLabel.text = file[@"infile"];
        cell2.outFileLabel.text = file[@"outfile"];
        cell2.paramTextField.text = file[@"params"];
        
        cell2.delegate = self;
    }
    return cell;
}

-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:true];
    if(indexPath.section == [self numberOfSectionsInTableView:_tableView]-1){
        [self showNewProcessPane];
    }
    
}
-(CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == [self numberOfSectionsInTableView:_tableView]-1){
        return 57;
    } else{
        return 100;
    }
}

-(CGFloat)tableView:(UITableView *)_tableView heightForHeaderInSection:(NSInteger)section{
    if(section == [self numberOfSectionsInTableView:_tableView]-1){
        return 0;
    } else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)_tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    v.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.f];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectInset(v.bounds, 15, 0)];
    l.text = [_tableView.dataSource tableView:_tableView titleForHeaderInSection:section];
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.f];
    [v addSubview:l];
    
    return v;
}

-(NSString *)tableView:(UITableView *)_tableView titleForHeaderInSection:(NSInteger)section{
    if(section == [self numberOfSectionsInTableView:_tableView]-1){
        return @"Button";
    } else{
        NSDictionary *d = contentArray[section];
        return [(NSString *)d[@"type"] capitalizedString];
    }
}


-(void)processCell2:(Process2Cell *)cell didChangeParams:(NSString *)params{
    NSIndexPath *cellIndex = [tableView indexPathForCell:cell];
    
    NSMutableDictionary *cellDict = [(NSDictionary *)contentArray[cellIndex.section] mutableCopy];
    
    NSMutableArray *a = [cellDict[@"files"] mutableCopy];
    NSMutableDictionary *d = [(NSDictionary *)a[cellIndex.row] mutableCopy];
    
    [d setObject:params forKey:@"params"];
    
    [a removeObjectAtIndex:cellIndex.row];
    [a insertObject:d.copy atIndex:cellIndex.row];
    
    [cellDict setObject:a forKey:@"files"];
    
    
    [contentArray removeObjectAtIndex:cellIndex.section];
    [contentArray insertObject:cellDict.copy atIndex:cellIndex.section];
    
}

-(void)showNewProcessPane {
    NSLog(@"self.tabbar: %@", self.tabBar2Controller);
    NSMutableArray *a = [[NSMutableArray alloc] initWithCapacity:processTypes.count];
    for(NSDictionary *d in processTypes){
        NSString *typename = d[@"type"];
        [a addObject:typename.capitalizedString];
    }
    
    [self.tabBar2Controller showOptions:a delegate:self];
}

-(void)optionsView:(OptionsView *)ov selectedIndex:(NSUInteger)index{
    NSArray *convertedFiles = [Process2ViewController convertExperimentFilesToAPI:filesToProcess type:processTypes[index]];
    NSDictionary *dict = @{@"type":processTypes[index][@"type"], @"files":convertedFiles.copy};
    [contentArray addObject:dict];
    [tableView insertSections:[NSIndexSet indexSetWithIndex:[self numberOfSectionsInTableView:tableView]-2] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}



+(NSArray *)convertExperimentFilesToAPI:(NSArray *)expFiles type:(NSDictionary *)d{
    NSMutableArray *a = [[NSMutableArray alloc] initWithCapacity:expFiles.count];
    for(ExperimentFile *f in expFiles){
        NSMutableArray *fileComps = [f.name componentsSeparatedByString:@"."].mutableCopy;
        [fileComps removeLastObject];
        NSString *filename = [fileComps componentsJoinedByString:@"."];
        NSDictionary *dict = @{@"infile":f.name, @"outfile":[NSString stringWithFormat:@"%@.%@", filename, d[@"file_ext"]], @"params":d[@"default_param"], @"genomeVersion":f.grVersion, @"keepSAM":@(true)};
        [a addObject:dict];
    }
    return a.mutableCopy;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
