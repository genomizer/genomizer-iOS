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
    NSArray *currentProcessTypes;
    UITextField *firstresponder;
    NSArray *colorArray;
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
//    tableView.separatorInset = UIEdgeInsetsMake(0, 160, 0, 160);
    tableView.separatorColor = [UIColor whiteColor];
    
    processTypes = @[@{@"type":@"rawToProfile",
                       @"file_ext":@"wig",
                       @"default_param":@"-f 9000",
                       @"snd_types":@[@"smoothie", @"step"]},

                     @{@"type":@"smoothie",
                       @"file_ext":@"smth",
                       @"default_param":@"-a 'ballong'",
                       @"snd_types":@[@"step"]},
                     
                     @{@"type":@"step",
                       @"file_ext":@"stsz",
                       @"snd_types":@[@"rawToProfile"]},
                     
                     @{@"type":@"ratio",
                       @"file_ext":@"stsz",
                       @"snd_types":@[],
                       @"nr_files":@(2)}];
    
    
    currentProcessTypes = processTypes.copy;
    
    colorArray = @[[UIColor colorWithRed:252/255.f green:115/255.f blue:65/255.f alpha:1.0],
                   [UIColor colorWithRed:84/255.f green:221/255.f blue:215/255.f alpha:1.0],
                   [UIColor colorWithRed:195/255.f green:122/255.f blue:254/255.f alpha:1.0],
                   [UIColor colorWithRed:81/255.f green:255/255.f blue:159/255.f alpha:1.0],
                   [UIColor greenColor], [UIColor blueColor], [UIColor yellowColor]];
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
    [firstresponder resignFirstResponder];
    ExperimentFile *firstFile = filesToProcess.firstObject;
    NSMutableArray *sendArray = [[NSMutableArray alloc] initWithCapacity:contentArray.count];
    for(NSDictionary *d in contentArray){
        NSMutableArray *files = [[NSMutableArray alloc] init];
        NSMutableDictionary *d_d = d.mutableCopy;
        for(NSDictionary *file in d[@"files"]){
            NSMutableDictionary *file_d = file.mutableCopy;
            if([d_d[@"type"] isEqualToString:@"rawToProfile"]){
                if([(NSString *) file_d[@"params"] length] == 0){
                    [file_d setObject:file_d[@"default_param"] forKey:@"params"];
                }
                [file_d removeObjectForKey:@"default_param"];
                
            } else if([d_d[@"type"] isEqualToString:@"ratio"]){
                id pre = file_d[@"infile"];
                id post= file_d[@"infile_post"];
                [file_d removeObjectForKey:@"infile"];
                [file_d removeObjectForKey:@"infile_post"];
                [file_d setObject:pre forKey:@"preChipFile"];
                [file_d setObject:post forKey:@"postChipFile"];
            }
            [file_d removeObjectForKey:@"outfile_ext"];
            [files addObject:file_d];
        }
        [d_d setValue:files.copy forKey:@"files"];
        [sendArray addObject:d_d];
    }
    
    NSDictionary *dict = @{@"expId":firstFile.expID, @"processCommands":sendArray};
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
    NSLog(@"JSON:\n%@", d1);

}
-(IBAction)addProcessTapped:(id)sender{
    [self showNewProcessPane];
}
-(IBAction)clearTapped:(id)sender{
    if([self numberOfSectionsInTableView:tableView] > 1){
        [firstresponder resignFirstResponder];
        currentProcessTypes = processTypes.copy;
        NSInteger sections = [self numberOfSectionsInTableView:tableView];
        [contentArray removeAllObjects];
        [tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sections)] withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView{
    int sec = contentArray.count == 0 ? 0 : contentArray.count+1;
    return sec;
}

-(NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger nrOfRows = 0;
    if(section != 0 && section == [self numberOfSectionsInTableView:_tableView]-1){
        NSDictionary *d = contentArray[section-1];
        nrOfRows = [(NSArray *)d[@"files"] count];
    } else if(contentArray.count > 0){
        if(contentArray.count >= section && [contentArray[section] isKindOfClass:[NSDictionary class]]){
            NSDictionary *d = contentArray[section];
            nrOfRows = [(NSArray *)d[@"files"] count];
        }
    }
    return nrOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(indexPath.section == [self numberOfSectionsInTableView:_tableView]-1){ //last cell
        cell = [_tableView dequeueReusableCellWithIdentifier:@"lastCell"];
        Process2Cell *cell2 = (Process2Cell *)cell;
        NSDictionary *file = contentArray[indexPath.section-1][@"files"][indexPath.row];
        UIColor *color = colorArray[indexPath.row];
        
        cell2.outFileTextField.textColor    = color;
        cell2.outFileTextField.text         = file[@"outfile"];
        cell2.outfile_ext                   = file[@"outfile_ext"];
        cell2.delegate = self;
        
    } else if(indexPath.section == 0){//first cell
        NSString *type = contentArray[indexPath.section][@"type"];
        
        cell = [_tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"processCell%@", type]];
        Process2Cell *cell2 = (Process2Cell *)cell;
        NSDictionary *file = contentArray[indexPath.section][@"files"][indexPath.row];
        UIColor *color = colorArray[indexPath.row];
        
        cell2.outFileTextField.textColor    = color;
        cell2.outFileTextField.text         = file[@"infile"];
        cell2.outFileTextField.enabled      = false;
        cell2.paramTextField.placeholder    = file[@"default_param"];
        cell2.paramTextField.text           = file[@"params"];
        
        //Step
        cell2.stepSizeTextField.text        = file[@"stepsize"];
        
        //Smooth
        cell2.minSmoothTextField.text       = file[@"minSmooth"];
        cell2.windowSizeTextField.text      = file[@"windowSize"];
        cell2.meanOrMedianTextField.text    = [file[@"meanOrMedian"] capitalizedString];
        
        //Ratio
        cell2.readsCutOffTextField.text     = file[@"readsCutoff"];
        cell2.chromosomeTextField.text      = file[@"chromosome"];
        cell2.outFilePostTextField.text     = file[@"infile_post"];
        
        cell2.delegate = self;
        
    }else{ //middle cells
        NSString *type = contentArray[indexPath.section][@"type"];
        cell = [_tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"processCell%@", type]];
        Process2Cell *cell2 = (Process2Cell *)cell;
        NSDictionary *file = contentArray[indexPath.section][@"files"][indexPath.row];
        NSDictionary *prevFile = contentArray[indexPath.section-1][@"files"][indexPath.row];
        UIColor *color = colorArray[indexPath.row];
        
        cell2.outFileTextField.textColor    = color;
        cell2.outFileTextField.text         = prevFile[@"outfile"];
        cell2.outFileTextField.enabled      = indexPath.section == 0 ? false : true;
        cell2.paramTextField.placeholder    = file[@"default_param"];
        cell2.paramTextField.text           = file[@"params"];
        cell2.outfile_ext                   = prevFile[@"outfile_ext"];
        cell2.stepSizeTextField.text        = file[@"stepsize"];
        cell2.minSmoothTextField.text       = file[@"minSmooth"];
        cell2.windowSizeTextField.text      = file[@"windowSize"];
        cell2.meanOrMedianTextField.text    = [file[@"meanOrMedian"] capitalizedString];
        
        cell2.readsCutOffTextField.text     = file[@"readsCutoff"];
        cell2.chromosomeTextField.text      = file[@"chromosome"];
        cell2.outFilePostTextField.text     = file[@"infile_post"];
        
        cell2.delegate = self;
    }
    return cell;
}

-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:true];
    if(indexPath.section == [self numberOfSectionsInTableView:_tableView]-1){
        
    }
    
}
-(CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == [self numberOfSectionsInTableView:_tableView]-1){
        return 39;
    } else{
        NSDictionary *d = contentArray[indexPath.section];
        if([d[@"type"] isEqualToString:@"ratio"]){
            return 90;
        }
        return 60;
    }
}

-(CGFloat)tableView:(UITableView *)_tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    } else{
        return 70;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(UIView *)tableView:(UITableView *)_tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title = [_tableView.dataSource tableView:_tableView titleForHeaderInSection:section];
    if(title.length > 0){
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
        v.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.f];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, v.frame.size.width, 20)];
        l.text = title.uppercaseString;
        l.textColor = [UIColor whiteColor];
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.f];
        [v addSubview:l];
        
        UIImageView *i = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 0, 200, 70)];
        i.image = [UIImage imageNamed:@"Arrow"];
        i.contentMode = UIViewContentModeScaleAspectFit;
        [v addSubview:i];
        
        return v;
    }
    return nil;
}

-(NSString *)tableView:(UITableView *)_tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"";
    } else{
        NSDictionary *d = contentArray[section-1];
        return [(NSString *)d[@"type"] capitalizedString];
    }
}


-(void)processCell2:(Process2Cell *)cell didChangeValue:(id)val forKey:(NSString *)key{
    firstresponder = nil;
    NSIndexPath *cellIndex = [tableView indexPathForCell:cell];
    [self changeValue:val forKey:key atSection:cellIndex];
}

-(void)changeValue:(id)val forKey:(NSString *)key atSection:(NSIndexPath *)cellIndex{

    
    NSMutableDictionary *cellDict = [(NSDictionary *)contentArray[cellIndex.section] mutableCopy];
    
    NSMutableArray *a = [cellDict[@"files"] mutableCopy];
    NSMutableDictionary *d = [(NSDictionary *)a[cellIndex.row] mutableCopy];
    
    [d setObject:val forKey:key];
    
    [a removeObjectAtIndex:cellIndex.row];
    [a insertObject:d.copy atIndex:cellIndex.row];
    
    [cellDict setObject:a forKey:@"files"];
    
    
    [contentArray removeObjectAtIndex:cellIndex.section];
    [contentArray insertObject:cellDict.copy atIndex:cellIndex.section];
}

-(void)processCell2:(Process2Cell *)cell didChangeOutFileName:(NSString *)outfileName{
    firstresponder = nil;
    NSIndexPath *cellIndex = [tableView indexPathForCell:cell];
    if(cellIndex == nil){
        return;
    }
    NSMutableDictionary *cellDict = [(NSDictionary *)contentArray[cellIndex.section-1] mutableCopy];
    
    NSMutableArray *a = [cellDict[@"files"] mutableCopy];
    NSMutableDictionary *d = [(NSDictionary *)a[cellIndex.row] mutableCopy];
    
    [d setObject:outfileName forKey:@"outfile"];
    
    [a removeObjectAtIndex:cellIndex.row];
    [a insertObject:d.copy atIndex:cellIndex.row];
    
    [cellDict setObject:a forKey:@"files"];
    
    [contentArray removeObjectAtIndex:cellIndex.section-1];
    [contentArray insertObject:cellDict.copy atIndex:cellIndex.section-1];
    
    if(cellIndex.section < [self numberOfSectionsInTableView:tableView]-1){
        NSMutableDictionary *cellDict = [(NSDictionary *)contentArray[cellIndex.section] mutableCopy];
        
        NSMutableArray *a = [cellDict[@"files"] mutableCopy];
        NSMutableDictionary *d = [(NSDictionary *)a[cellIndex.row] mutableCopy];
        
        [d setObject:outfileName forKey:@"infile"];
        
        [a removeObjectAtIndex:cellIndex.row];
        [a insertObject:d.copy atIndex:cellIndex.row];
        
        [cellDict setObject:a forKey:@"files"];
        
        [contentArray removeObjectAtIndex:cellIndex.section];
        [contentArray insertObject:cellDict.copy atIndex:cellIndex.section];
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cellIndex.row inSection:cellIndex.section+1]] withRowAnimation:UITableViewRowAnimationFade];
    }

}

-(void)processCell2DidBeginEdit:(UITextField *)textField{
    firstresponder = textField;
}
-(void)showNewProcessPane {
    [firstresponder resignFirstResponder];
    NSMutableArray *a = [[NSMutableArray alloc] initWithCapacity:currentProcessTypes.count];
    for(NSDictionary *d in currentProcessTypes){
        NSString *typename = d[@"type"];
        if(d[@"nr_files"]){
            NSNumber *nr_files = d[@"nr_files"];
            if(nr_files.intValue == filesToProcess.count){
                [a addObject:typename.capitalizedString];
            }
        } else{
            [a addObject:typename.capitalizedString];
        }
        
    }
    
    [self.tabBar2Controller showOptions:a delegate:self];
    
}

-(void)optionsView:(OptionsView *)ov selectedIndex:(NSUInteger)index{
    NSArray *prevFiles = nil;

    //Gets the previous out file extension
    if([self numberOfSectionsInTableView:tableView] > 0){
        prevFiles = contentArray[[self numberOfSectionsInTableView:tableView]-2][@"files"];
    }
    
    //Converts the files to the new type
    NSArray *convertedFiles = [Process2ViewController convertExperimentFilesToAPI:filesToProcess type:currentProcessTypes[index] prevFiles:prevFiles];
    NSDictionary *dict = @{@"type":currentProcessTypes[index][@"type"], @"files":convertedFiles.copy};
    int lastNrSections = [self numberOfSectionsInTableView:tableView];;
    [contentArray addObject:dict];
    int currentNrSections = [self numberOfSectionsInTableView:tableView];
//    [tableView reloadData];
    [tableView beginUpdates];
    [tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(lastNrSections, currentNrSections-lastNrSections)] withRowAnimation:UITableViewRowAnimationTop];
    if(lastNrSections > 0){
        [tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(lastNrSections-1, 1)] withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView endUpdates];
    //Updates the currentProcessTypes to match the selected types snd_types
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for(NSString *s in currentProcessTypes[index][@"snd_types"]){
        NSDictionary *d = [self getTypeWithName:s];
        if(d != nil){
            [temp addObject:d];
        }
    }
    currentProcessTypes = temp.copy;
    
}

-(NSDictionary *)getTypeWithName:(NSString *)name{
    NSDictionary *type = nil;
    for(NSDictionary *d in processTypes){
        if([name isEqualToString:d[@"type"]]){
            type = d;
            break;
        }
    }
    return type;
}


+(NSArray *)convertExperimentFilesToAPI:(NSArray *)expFiles type:(NSDictionary *)d prevFiles:(NSArray *)prevFiles{
    
    if([d[@"type"] isEqualToString:@"ratio"]){
        ExperimentFile *pre = expFiles[0];
        ExperimentFile *post = expFiles[1];
        NSMutableArray *fileComps = [pre.name componentsSeparatedByString:@"."].mutableCopy;
        [fileComps removeLastObject];
        NSString *filename = [fileComps componentsJoinedByString:@"."];
        
        NSDictionary *dict = @{@"infile":pre.name,@"infile_post":post.name, @"outfile":[NSString stringWithFormat:@"%@.%@", filename, d[@"file_ext"]], @"mean":@"single", @"readsCutoff":@"", @"outfile_ext":d[@"file_ext"], @"chromosome":@""};
        return @[dict];
    }
    NSMutableArray *a = [[NSMutableArray alloc] initWithCapacity:expFiles.count];
    for(int i = 0; i < expFiles.count; i++){
        ExperimentFile *f = expFiles[i];
        NSDictionary *prevD = prevFiles[i];
        
        NSMutableArray *fileComps = [f.name componentsSeparatedByString:@"."].mutableCopy;
        [fileComps removeLastObject];
        NSString *filename = [fileComps componentsJoinedByString:@"."];
        NSString *infile_final = prevD == nil ? f.name : [NSString stringWithFormat:@"%@.%@", filename, prevD[@"outfile_ext"]];
        infile_final = prevD == nil ? infile_final : prevD[@"outfile"];
        NSDictionary *dict = nil;
        if([d[@"type"] isEqualToString:@"rawToProfile"]){
            dict = @{@"infile":infile_final, @"outfile":[NSString stringWithFormat:@"%@.%@", filename, d[@"file_ext"]], @"params":@"", @"default_param":d[@"default_param"], @"genomeVersion":f.grVersion, @"keepSAM":@(true), @"outfile_ext":d[@"file_ext"]};
        } else if([d[@"type"] isEqualToString:@"step"]){
            dict = @{@"infile":infile_final, @"outfile":[NSString stringWithFormat:@"%@.%@", filename, d[@"file_ext"]], @"stepsize":@"", @"outfile_ext":d[@"file_ext"]};
        } else if([d[@"type"] isEqualToString:@"smoothie"]){
            dict = @{@"infile":infile_final, @"outfile":[NSString stringWithFormat:@"%@.%@", filename, d[@"file_ext"]], @"windowSize":@"", @"minSmooth":@"", @"outfile_ext":d[@"file_ext"], @"meanOrMedian":@"Mean"};
        } else if([d[@"type"] isEqualToString:@"ratio"]){
 
        }
        [a addObject:dict];
    }
    return a.copy;
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
