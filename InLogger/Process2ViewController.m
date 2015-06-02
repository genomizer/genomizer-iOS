//
//  Process2ViewController.m
//  Genomizer
//
//  Created by Pål Forsberg on 25/05/15.
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
    tableView.separatorColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    processTypes = @[@{@"type":@"rawToProfile",
                       @"name":@"Raw to Profile",
                       @"file_ext":@"wig",
                       @"infile_ext":@"fastq",
                       @"default_param":@"-a -m 1 --best -p 10 -v 2 -q -S--phred33",
                       @"snd_types":@[@"smoothing", @"step"]},

                     @{@"type":@"smoothing",
                       @"name":@"Smoothie",
                       @"file_ext":@"sgr",
                       @"infile_ext":@"sgr",
                       @"default_param":@"-a 'ballong'",
                       @"snd_types":@[@"step"]},
                     
                     @{@"type":@"step",
                       @"name":@"Step Size",
                       @"file_ext":@"sgr",
                       @"infile_ext":@"sgr",
                       @"snd_types":@[@"smoothing"]},
                     
                     @{@"type":@"ratio",
                       @"name":@"Ratio",
                       @"file_ext":@"sgr",
                       @"infile_ext":@"sgr",
                       @"snd_types":@[@"step", @"smoothing"],
                       @"nr_files":@(2)}];
    
    ExperimentFile *file = filesToProcess.firstObject;
    NSArray *fileNameComps = [file.name componentsSeparatedByString:@"."];
    NSString *extension = fileNameComps.lastObject;
    [self updateCurrentProcessTypes:extension numberFiles:filesToProcess.count];
    
    colorArray = @[[UIColor colorWithRed:252/255.f green:115/255.f blue:65/255.f alpha:1.0],
                   [UIColor colorWithRed:195/255.f green:122/255.f blue:254/255.f alpha:1.0],
                   [UIColor colorWithRed:81/255.f green:255/255.f blue:159/255.f alpha:1.0],
                   [UIColor colorWithRed:84/255.f green:221/255.f blue:215/255.f alpha:1.0],
                   [UIColor colorWithRed:244/255.f green:194/255.f blue:10/255.f alpha:1.0],
                   [UIColor colorWithRed:220/255.f green:118/255.f blue:223/255.f alpha:1.0],
                   [UIColor colorWithRed:196/255.f green:29/255.f blue:130/255.f alpha:1.0],
                   [UIColor colorWithRed:160/255.f green:81/255.f blue:75/255.f alpha:1.0],
                   [UIColor colorWithRed:110/255.f green:110/255.f blue:110/255.f alpha:1.0],
                   [UIColor greenColor], [UIColor blueColor], [UIColor yellowColor]];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tapper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

//Dismisses keyboard on tap outside of it.
-(void)tapped:(UITapGestureRecognizer *)tapper{
    if(firstresponder){
        [firstresponder resignFirstResponder];
    }
}

//Removes all extra value-key and sends the request to the server.
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
            } else if([d_d[@"type"] isEqualToString:@"smoothing"]){
                NSString *meanOrMedian = file_d[@"meanOrMedian"];
                [file_d setObject:meanOrMedian.lowercaseString forKey:@"meanOrMedian"];
            }
            [file_d removeObjectForKey:@"outfile_ext"];
            [files addObject:file_d];
        }
        [d_d setValue:files.copy forKey:@"files"];
        [sendArray addObject:d_d];
    }
    
    NSDictionary *dict = @{@"expId":firstFile.expID, @"processCommands":sendArray};
    [[[ServerConnection alloc] init ] convert:dict withContext:^(NSError *errold, NSString *expId) {
        NSLog(@"Convert sent:  %@ %@ %@", expId, errold.localizedDescription, errold);
        if(errold != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tabBar2Controller showPopDownWithError:errold];
            });
        } else{
            [self.tabBar2Controller showPopDownWithTitle:@"Process sent" andMessage:expId type:@"success"];
            [self.navigationController popViewControllerAnimated:true];
        }
        
    }];
    
     NSData *d = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSDictionary *d1 = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
    NSLog(@"JSON:\n%@", d1);

}

//Gets called when the Add Process button is tapped
//Shows a menu with available processes
-(IBAction)addProcessTapped:(id)sender{
    [self showNewProcessPane];
}
//Gets called when the Clear button is tapped
//Removes all added processes.
-(IBAction)clearTapped:(id)sender{
    if([self numberOfSectionsInTableView:tableView] > 1){
        [firstresponder resignFirstResponder];
        
        ExperimentFile *file = filesToProcess.firstObject;
        NSArray *fileNameComps = [file.name componentsSeparatedByString:@"."];
        NSString *extension = fileNameComps.lastObject;
        [self updateCurrentProcessTypes:extension numberFiles:filesToProcess.count];
        
        NSInteger sections = [self numberOfSectionsInTableView:tableView];
        [contentArray removeAllObjects];
        [tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sections)] withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView{
    NSInteger sec = contentArray.count == 0 ? 0 : contentArray.count+1;
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
        
        cell2.fileTextField.textColor    = color;
        cell2.fileTextField.text         = file[@"outfile"];
        cell2.outfile_ext                   = file[@"outfile_ext"];
        cell2.delegate = self;
        
    } else{ //first and middle cells
        NSString *type = contentArray[indexPath.section][@"type"];
        cell = [_tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"processCell%@", type]];
        Process2Cell *cell2 = (Process2Cell *)cell;
        NSDictionary *file = contentArray[indexPath.section][@"files"][indexPath.row];
        NSDictionary *prevFile = nil;
        if(indexPath.section > 0){
            prevFile = contentArray[indexPath.section-1][@"files"][indexPath.row];
        }
        UIColor *color = colorArray[indexPath.row];
        
        cell2.fileTextField.textColor    = color;
        
        cell2.fileTextField.enabled      = indexPath.section == 0 ? false : true;
        cell2.filePostTextField.enabled  = indexPath.section == 0 ? false : true;
        cell2.paramTextField.placeholder    = file[@"default_param"];
        cell2.paramTextField.text           = file[@"params"];
        
        if(prevFile){
            cell2.fileTextField.text         = prevFile[@"outfile"];
            cell2.outfile_ext                   = prevFile[@"outfile_ext"];
        } else{
            cell2.fileTextField.text         = file[@"infile"];
            cell2.outfile_ext                   = nil;
        }

        //Step
        cell2.stepSizeTextField.text        = file[@"stepsize"];
        
        //Smooth
        cell2.minSmoothTextField.text       = file[@"minSmooth"];
        cell2.windowSizeTextField.text      = file[@"windowSize"];
        cell2.meanOrMedianTextField.text    = [file[@"meanOrMedian"] capitalizedString];
        
        //Ratio
        cell2.readsCutOffTextField.text     = file[@"readsCutOff"];
        cell2.chromosomeTextField.text      = file[@"chromosomes"];
        cell2.filePostTextField.text     = file[@"infile_post"];
        cell2.switchButton.hidden           = indexPath.section == 0 ? false : true;
        if([type isEqualToString:@"ratio"]){
            cell2.filePostTextField.textColor = colorArray[1];
        }
        
        cell2.delegate = self;
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 17, 0, 0);
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
            return 102;
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

//User change the value in a textfield in cell cell
-(void)processCell2:(Process2Cell *)cell didChangeValue:(id)val forKey:(NSString *)key{
    [self processCell2:cell didChangeValue:val forKey:key forceReload:false];
}
/**
 * Delegate, gets called when the user changes a value in a cell.
 *
 * @param cell - Cell which user the has changed a textfield in
 * @param val - New value
 * @param key - The values key in the content array array
 * @param force - Forces the table to reload the cell
 */
-(void)processCell2:(Process2Cell *)cell didChangeValue:(id)val forKey:(NSString *)key forceReload:(BOOL)force{

    NSIndexPath *cellIndex = [tableView indexPathForCell:cell];
    if([key isEqualToString:@"infile_post"]){
        [self changeValue:val forKey:@"outfile" atSection:[NSIndexPath indexPathForRow:cellIndex.row inSection:cellIndex.section]];
    }
    [self changeValue:val forKey:key atSection:cellIndex];

    if(force){
        [tableView reloadRowsAtIndexPaths:@[cellIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/**
 * Changes the value to val for key key in contentArray
 *
 * @param val - New value
 * @param key - The values key in the content array array
 * @param cellIndex - The index of the cell which content should be changed
 */
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

/**
 * Delegate, gets called when the user changes a file name.
 *
 * @param cell - Cell which user the has changed a textfield in
 * @param outfileName - New name for outfile.
 */
-(void)processCell2:(Process2Cell *)cell didChangeOutFileName:(NSString *)outfileName{

    NSIndexPath *cellIndex = [tableView indexPathForCell:cell];
    if(cellIndex == nil){
        return;
    }
    NSIndexPath *curr = [NSIndexPath indexPathForRow:cellIndex.row inSection:cellIndex.section-1];
    [self changeValue:outfileName forKey:@"outfile" atSection:curr];
    
    if(cellIndex.section < [self numberOfSectionsInTableView:tableView]-1){
        [self changeValue:outfileName forKey:@"infile" atSection:cellIndex];
        
    }
}

/**
 * Delegate, gets called when the user begins to edit a textfield
 *
 * @param cell - Cell which user the has changed a textfield in
 */
-(void)processCell2:(Process2Cell *)cell didBeginEdit:(UITextField *)textField{
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    CGRect cellFrame = [tableView rectForRowAtIndexPath:indexPath];
    CGFloat diff = self.view.frame.size.height - 250 - (cellFrame.origin.y + cellFrame.size.height - tableView.contentOffset.y);
    if(diff < 0){
        [UIView animateWithDuration:0.2 animations:^{
            tableView.transform = CGAffineTransformMakeTranslation(0, diff);
        }];
    }
    firstresponder = textField;
}
/**
 * Delegate, gets called when the user ends to edit a textfield
 *
 * @param cell - Cell which user the has changed a textfield in
 */
-(void)processCell2:(Process2Cell *)cell didEndEdit:(UITextField *)textField{
    [UIView animateWithDuration:0.2 animations:^{
        tableView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    firstresponder = nil;
}

/**
 * Shows a menu with the processes in currentProcessTypes
 */
-(void)showNewProcessPane {
    [firstresponder resignFirstResponder];
    NSMutableArray *a = [[NSMutableArray alloc] initWithCapacity:currentProcessTypes.count];
    NSString *extension = nil;
    if(contentArray.count == 0){
        ExperimentFile *firstFile = filesToProcess.firstObject;
        NSArray *fileNameComps = [firstFile.name componentsSeparatedByString:@"."];
        extension = fileNameComps.lastObject;
    }
    
    for(NSDictionary *d in currentProcessTypes){
        NSString *typename = d[@"name"];
        [a addObject:typename];
    }
    
    [self.tabBar2Controller showOptions:a delegate:self];
    
}
/**
 * Delegate, gets called when the user has selected a process type.
 * Adds entries to contentarray and insert to tableView
 *
 * @param ov - callee
 * @param index - selected index in ov
 */
-(void)optionsView:(OptionsView *)ov selectedIndex:(NSUInteger)index{
    NSArray *prevFiles = nil;
    NSArray *convertedFiles = nil;
    //Gets the previous out file extension
    if([self numberOfSectionsInTableView:tableView] > 0){
        prevFiles = contentArray[[self numberOfSectionsInTableView:tableView]-2][@"files"];
        convertedFiles = [Process2ViewController convertToNewType:currentProcessTypes[index] prevFiles:prevFiles];
    } else{
        convertedFiles = [Process2ViewController convertExperimentFilesToAPI:filesToProcess type:currentProcessTypes[index]];
    }
    NSDictionary *dict = @{@"type":currentProcessTypes[index][@"type"], @"files":convertedFiles.copy};
    NSInteger lastNrSections = [self numberOfSectionsInTableView:tableView];;
    [contentArray addObject:dict];
    NSInteger currentNrSections = [self numberOfSectionsInTableView:tableView];

    [tableView beginUpdates];
    [tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(lastNrSections, currentNrSections-lastNrSections)] withRowAnimation:UITableViewRowAnimationTop];
    if(lastNrSections > 0){
        [tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(lastNrSections-1, 1)] withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView endUpdates];
    //Updates the currentProcessTypes to match the selected types snd_types
    NSString *outExt = currentProcessTypes[index][@"file_ext"];
    NSInteger nrOfFiles = [(NSArray *)contentArray[currentNrSections-2][@"files"] count];

    [self updateCurrentProcessTypes:outExt numberFiles:nrOfFiles];
}

/**
 * Updates currentProcessTypes to match the last outfile.
 *
 * @param inExt - extension of the outfile
 * @param nrOfFiles - number of files which is the result of the last process.
 */
-(void)updateCurrentProcessTypes:(NSString *)inExt numberFiles:(NSInteger)nrOfFiles{

    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for(NSDictionary *d in processTypes){
        if([d[@"infile_ext"] isEqualToString:inExt]){
            if(d[@"nr_files"]){
                NSNumber *inNrFiles = d[@"nr_files"];
                if(inNrFiles.integerValue != nrOfFiles){
                    continue;
                }
            }
            [temp addObject:d];
        }
    }
    currentProcessTypes = temp.copy;
}

/**
 * Converts from ExperimentFile to dictionary which better matches the API
 *
 * @param expFiles - ExperimentFiles to be converted.
 * @param d - type to convert to.
 */
+(NSArray *)convertExperimentFilesToAPI:(NSArray *)expFiles type:(NSDictionary *)d{
    
    if([d[@"type"] isEqualToString:@"ratio"]){
        ExperimentFile *pre = expFiles[0];
        ExperimentFile *post = expFiles[1];
        NSMutableArray *fileComps = [pre.name componentsSeparatedByString:@"."].mutableCopy;
        [fileComps removeLastObject];
        NSString *filename = [fileComps componentsJoinedByString:@"."];
        
        NSDictionary *dict = @{@"infile":pre.name,@"infile_post":post.name, @"outfile":[NSString stringWithFormat:@"%@.%@", filename, d[@"file_ext"]], @"mean":@"single", @"readsCutOff":@"", @"outfile_ext":d[@"file_ext"], @"chromosomes":@""};
        return @[dict];
    }
    NSMutableArray *a = [[NSMutableArray alloc] initWithCapacity:expFiles.count];
    for(int i = 0; i < expFiles.count; i++){
        ExperimentFile *f = expFiles[i];

        NSMutableArray *fileComps = [f.name componentsSeparatedByString:@"."].mutableCopy;
        [fileComps removeLastObject];
        NSString *filename = [fileComps componentsJoinedByString:@"."];
        NSString *infile_final = f.name;
        
        NSDictionary *dict = nil;
        if([d[@"type"] isEqualToString:@"rawToProfile"]){
            dict = @{@"infile":infile_final, @"outfile":[NSString stringWithFormat:@"%@.%@", filename, d[@"file_ext"]], @"params":@"", @"default_param":d[@"default_param"], @"genomeVersion":f.grVersion, @"keepSam":@"true", @"outfile_ext":d[@"file_ext"],@"sortSamStringency":@"STRICT"};
        } else if([d[@"type"] isEqualToString:@"step"]){
            dict = @{@"infile":infile_final, @"outfile":[NSString stringWithFormat:@"%@.%@", filename, d[@"file_ext"]], @"stepSize":@"", @"outfile_ext":d[@"file_ext"]};
        } else if([d[@"type"] isEqualToString:@"smoothing"]){
            dict = @{@"infile":infile_final, @"outfile":[NSString stringWithFormat:@"%@.%@", filename, d[@"file_ext"]], @"windowSize":@"", @"minSmooth":@"", @"outfile_ext":d[@"file_ext"], @"meanOrMedian":@"Mean"};
        } else if([d[@"type"] isEqualToString:@"ratio"]){
            
        }
        [a addObject:dict];
    }
    return a.copy;
}


/**
 * Converts old type to new type which almost matches the API
 *
 * @param expFiles - ExperimentFiles to be converted.
 * @param d - type to convert to.
 */
+(NSArray *)convertToNewType:(NSDictionary *)d prevFiles:(NSArray *)prevFiles{
    if([d[@"type"] isEqualToString:@"ratio"]){
        NSDictionary *pre = prevFiles[0];
        NSDictionary *post = prevFiles[1];
        NSMutableArray *fileComps = [pre[@"outfile"] componentsSeparatedByString:@"."].mutableCopy;
        [fileComps removeLastObject];
        NSString *filename = [fileComps componentsJoinedByString:@"."];
        
        NSDictionary *dict = @{@"infile":pre[@"outfile"],@"infile_post":post[@"outfile"], @"outfile":[NSString stringWithFormat:@"%@.%@", filename, d[@"file_ext"]], @"mean":@"single", @"readsCutOff":@"", @"outfile_ext":d[@"file_ext"], @"chromosomes":@""};
        return @[dict];
    }
    NSMutableArray *a = [[NSMutableArray alloc] initWithCapacity:prevFiles.count];
    for(int i = 0; i < prevFiles.count; i++){
        NSDictionary *prevD = prevFiles[i];
        NSString *fname = prevD[@"outfile"];
        NSMutableArray *fileComps = [fname componentsSeparatedByString:@"."].mutableCopy;
        [fileComps removeLastObject];
        NSString *filename = [fileComps componentsJoinedByString:@"."];
        NSString *infile_final = prevD == nil ? fname : [NSString stringWithFormat:@"%@.%@", filename, prevD[@"outfile_ext"]];
        infile_final = prevD == nil ? infile_final : prevD[@"outfile"];
        NSDictionary *dict = nil;
        if([d[@"type"] isEqualToString:@"rawToProfile"]){
            dict = @{@"infile":infile_final, @"outfile":[NSString stringWithFormat:@"%@.%@", filename, d[@"file_ext"]], @"params":d[@"default_param"], @"genomeVersion":@"", @"keepSAM":@(true), @"outfile_ext":d[@"file_ext"],@"sortSamStringency":@"STRICT"};
        } else if([d[@"type"] isEqualToString:@"step"]){
            dict = @{@"infile":infile_final, @"outfile":[NSString stringWithFormat:@"%@.%@", filename, d[@"file_ext"]], @"stepSize":@"", @"outfile_ext":d[@"file_ext"]};
        } else if([d[@"type"] isEqualToString:@"smoothing"]){
            dict = @{@"infile":infile_final, @"outfile":[NSString stringWithFormat:@"%@.%@", filename, d[@"file_ext"]], @"windowSize":@"", @"minSmooth":@"", @"outfile_ext":d[@"file_ext"], @"meanOrMedian":@"Mean"};
        }
        [a addObject:dict];
    }
    return a.copy;
}


@end
