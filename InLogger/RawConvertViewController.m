//
//  RawConvertViewController.m
//  InLogger
//
//  Created by Linus Öberg on 08/05/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import "RawConvertViewController.h"
#import "XYZExperimentFile.h"
#import "ServerConnection.h"
#import "XYZPopupGenerator.h"

#import <QuartzCore/QuartzCore.h>
#import "ProcessViewController.h"
@interface RawConvertViewController ()

@property (weak, nonatomic) IBOutlet UITextField *bowtie;
@property (weak, nonatomic) IBOutlet UITextField *genomeFile;
@property (weak, nonatomic) IBOutlet UITextField *smoothingWindowSize;
@property (weak, nonatomic) IBOutlet UISwitch *smoothingSmoothTypeSwitch;
@property (weak, nonatomic) IBOutlet UITextField *smoothingMinimumStep;
@property (weak, nonatomic) IBOutlet UISwitch *smoothingPrintMean;
@property (weak, nonatomic) IBOutlet UISwitch *smoothingPrintZeros;
@property (weak, nonatomic) IBOutlet UISwitch *stepCreateStep;
@property (weak, nonatomic) IBOutlet UITextField *step;
@property (weak, nonatomic) IBOutlet UISwitch *samToGff;
@property (weak, nonatomic) IBOutlet UISwitch *gffToSgr;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ratioCalcDoubleSingle;
@property (weak, nonatomic) IBOutlet UITextField *ratioCalcInputReads;
@property (weak, nonatomic) IBOutlet UITextField *ratioCalcChromosomes;
@property (weak, nonatomic) IBOutlet UITextField *ratioCalcSmoothingWindowSize;
@property (weak, nonatomic) IBOutlet UISwitch *ratioCalcSmoothingSmoothType;
@property (weak, nonatomic) IBOutlet UITextField *ratioCalcSmoothingMinimumStep;
@property (weak, nonatomic) IBOutlet UISwitch *ratioCalcSmoothingPrintMean;
@property (weak, nonatomic) IBOutlet UISwitch *ratioCalcSmoothingPrintZeros;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableViewCell *ratioCalcCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *ratioCalcSmoothingCell;
@property NSMutableArray* numpadFields;
@property NSMutableArray* switches;

@property CGPoint originalCenter;
@property NSMutableArray *experimentFilesDictArr;
@property UIGestureRecognizer *tapper;


@end

@implementation RawConvertViewController{
    __weak UIView *_staticView;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.numpadFields = [[NSMutableArray alloc] init];
    [self.numpadFields addObject:self.smoothingWindowSize];
    [self.numpadFields addObject:self.smoothingMinimumStep];
    [self.numpadFields addObject:self.step];
    [self.numpadFields addObject:self.ratioCalcInputReads];
    [self.numpadFields addObject:self.ratioCalcChromosomes];
    [self.numpadFields addObject:self.ratioCalcSmoothingWindowSize];
    [self.numpadFields addObject:self.ratioCalcSmoothingMinimumStep];
    
    for(UITextField * text in self.numpadFields){
        text.enabled = NO;
        text.delegate = self;
    }
    
    self.switches = [[NSMutableArray alloc] init];
    [self.switches addObject:self.samToGff];
    [self.switches addObject:self.gffToSgr];
    [self.switches addObject:self.smoothingSmoothTypeSwitch];
    [self.switches addObject:self.smoothingPrintMean];
    [self.switches addObject:self.smoothingPrintZeros];
    [self.switches addObject:self.stepCreateStep];
    [self.switches addObject:self.ratioCalcSmoothingSmoothType];
    [self.switches addObject:self.ratioCalcSmoothingPrintMean];
    [self.switches addObject:self.ratioCalcSmoothingPrintZeros];
    
    for(UISwitch * switches in self.switches){
        switches.enabled = NO;
        switches.on = NO;
    }
    
    _tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    _tapper.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:_tapper];
    self.bowtie.delegate = self;
    self.genomeFile.delegate = self;
    self.genomeFile.enabled = NO;
    self.originalCenter = self.view.center;
    if(_ratio){
        _ratioCalcCell.hidden = NO;
        _ratioCalcSmoothingCell.hidden = NO;
    }
   
    UIView *staticView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bounds.size.height-50, self.tableView.bounds.size.width, 50)];
    staticView.backgroundColor = [UIColor whiteColor];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    [button setTitle:@"Convert" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(convertButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake(self.tableView.bounds.size.width/2-65, 10, 130, 30);
    [staticView addSubview:button];
    staticView.clipsToBounds = YES;
    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderColor = [UIColor lightGrayColor].CGColor;
    rightBorder.borderWidth = 1;
    rightBorder.frame = CGRectMake(0, -1.5, CGRectGetWidth(staticView.frame), 2);
    [staticView.layer addSublayer:rightBorder];
    [self.tableView addSubview:staticView];
    _staticView = staticView;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    if(self.bowtie.text.length > 0){
        self.genomeFile.enabled = YES;
    }
    if(self.genomeFile.text.length > 0){
        self.samToGff.enabled = YES;
    }
    [self.view endEditing:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _staticView.transform = CGAffineTransformMakeTranslation(0, scrollView.contentOffset.y);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // this is needed to prevent cells from being displayed above our static view
    [self.tableView bringSubviewToFront:_staticView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length == 0){
        if(textField == self.bowtie) {
            self.genomeFile.enabled = NO;
            self.genomeFile.text = @"";
            for(UITextField *text in self.numpadFields){
                text.enabled = NO;
                text.text=@"";
            }
            for(UISwitch *switches in self.switches){
                switches.enabled = NO;
                switches.on = NO;
            }
        
        } else if(textField == self.genomeFile) {
            for(UITextField *text in self.numpadFields){
                text.enabled = NO;
                text.text=@"";
            }
            for(UISwitch *switches in self.switches){
                switches.enabled = NO;
                switches.on = NO;
            }
        
        }else if((textField == self.smoothingMinimumStep || textField == self.smoothingWindowSize) && ((self.smoothingWindowSize.text.length == 0) || (self.smoothingMinimumStep.text.length == 0) || (!self.smoothingPrintMean.enabled) || (!self.smoothingPrintZeros.enabled) || (!self.smoothingSmoothTypeSwitch.enabled))) {
            for(int i = 2; i < self.numpadFields.count; i++){
                UITextField *text = [self.numpadFields objectAtIndex:i];
                text.enabled=NO;
                text.text = @"";
            }
            for(int i = 5; i < self.switches.count; i++){
                UISwitch *switchen = [self.switches objectAtIndex:i];
                switchen.enabled = NO;
                switchen.on = NO;
            }
        }
        else if(textField == self.step) {
            for(int i = 3; i < self.numpadFields.count; i++){
                UITextField *text = [self.numpadFields objectAtIndex:i];
                text.enabled=NO;
                text.text = @"";
            }
            for(int i = 6; i < self.switches.count; i++){
                UISwitch *switchen = [self.switches objectAtIndex:i];
                switchen.enabled = NO;
                switchen.on = NO;
            }
        }
        else if((textField == self.ratioCalcInputReads || textField == self.ratioCalcChromosomes) && ((self.ratioCalcInputReads.text.length == 0) || (self.ratioCalcChromosomes.text.length == 0))) {
            for(int i = 5; i < self.numpadFields.count; i++){
                UITextField *text = [self.numpadFields objectAtIndex:i];
                text.enabled=NO;
                text.text = @"";
            }
            for(int i = 6; i < self.switches.count; i++){
                UISwitch *switchen = [self.switches objectAtIndex:i];
                switchen.enabled = NO;
                switchen.on = NO;
            }
        }
    } else{
        if(((textField == self.smoothingWindowSize) || (textField == self.smoothingMinimumStep)) && (self.smoothingWindowSize.text.length > 0) && (self.smoothingMinimumStep.text.length > 0)) {
            self.stepCreateStep.enabled = YES;
            self.step.enabled = YES;
        }
        else if(textField == self.step){
            if(_ratio){
                self.ratioCalcDoubleSingle.enabled = YES;
                self.ratioCalcInputReads.enabled = YES;
                self.ratioCalcChromosomes.enabled = YES;
            }else{
                NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
                [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }else if(((textField == self.ratioCalcInputReads) || (textField == self.ratioCalcChromosomes)) && (self.ratioCalcInputReads.text.length > 0) && (self.ratioCalcChromosomes.text.length > 0)){
            self.ratioCalcSmoothingWindowSize.enabled = YES;
            self.ratioCalcSmoothingSmoothType.enabled = YES;
            self.ratioCalcSmoothingMinimumStep.enabled = YES;
            self.ratioCalcSmoothingPrintMean.enabled = YES;
            self.ratioCalcSmoothingPrintZeros.enabled = YES;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
if(textField.text.length > 0 ){
    if(textField == self.bowtie) {
        self.genomeFile.enabled = YES;
    } else if(textField == self.genomeFile) {
        self.samToGff.enabled = YES;
    }else if((textField == self.smoothingWindowSize) && (self.smoothingMinimumStep.text.length > 0)) {
        
    }else if(textField == self.smoothingMinimumStep) {
        self.smoothingPrintMean.enabled = YES;
    }else if(textField == self.step) {
       self.ratioCalcDoubleSingle.enabled = YES;
    }else if(textField == self.ratioCalcInputReads) {
        self.ratioCalcChromosomes.enabled = YES;
    }else if(textField == self.ratioCalcChromosomes) {
        self.ratioCalcSmoothingWindowSize.enabled = YES;
    }else if(textField == self.ratioCalcSmoothingWindowSize) {
        self.ratioCalcSmoothingSmoothType.enabled = YES;
    }else if(textField == self.ratioCalcSmoothingMinimumStep) {
        self.ratioCalcSmoothingPrintMean.enabled = YES;
    }
    [textField endEditing:YES];
}
return NO;
}

- (IBAction)convertButtonTouch:(id)sender
{
    if(_bowtie.text.length == 0){
            [XYZPopupGenerator showPopupWithMessage:@"Fill in desired fields to process"];
    }else{
        NSMutableArray * parameters = [[NSMutableArray alloc] init];
        [parameters addObject:_bowtie.text];
        [parameters addObject:_genomeFile.text];
        if(_samToGff.on){
            [parameters addObject:@"y"];
        }
        else{
            [parameters addObject:@""];
        }
        if(_gffToSgr.on){
            [parameters addObject:@"y"];
        }
        else{
            [parameters addObject:@""];
        }
        if((self.smoothingWindowSize.text.length > 0) && (self.smoothingMinimumStep.text.length > 0) && ([self.smoothingWindowSize.text intValue] > 0)){
            NSString *text = self.smoothingWindowSize.text;
            text = [text stringByAppendingString:@" "];
            if (self.smoothingSmoothTypeSwitch.on){
                text = [text stringByAppendingString:@"1"];
            }else{
                text = [text stringByAppendingString:@"0"];
            }
            text = [text stringByAppendingString:@" "];
            text = [text stringByAppendingString:self.smoothingMinimumStep.text];
            text = [text stringByAppendingString:@" "];
            if (self.smoothingPrintMean.on){
                text = [text stringByAppendingString:@"1"];
            }else{
                text = [text stringByAppendingString:@"0 "];
            }
            text = [text stringByAppendingString:@" "];
            if (self.smoothingPrintZeros.on){
                text = [text stringByAppendingString:@"1"];
            }else{
                text = [text stringByAppendingString:@"0"];
            }
             [parameters addObject:text];
        }else{
            [parameters addObject:@""];
        }
        if((self.ratioCalcInputReads.text.length > 0) && (self.ratioCalcChromosomes.text.length > 0)){
            NSString *text = [self.ratioCalcDoubleSingle titleForSegmentAtIndex:self.ratioCalcDoubleSingle.selectedSegmentIndex];
            text = [text stringByAppendingString:@" "];
            text = [text stringByAppendingString:self.ratioCalcInputReads.text];
            text = [text stringByAppendingString:@" "];
            text = [text stringByAppendingString:self.ratioCalcChromosomes.text];
            [parameters addObject:text];
        }else{
            [parameters addObject:@""];
        }
        
        if((self.step.text.length > 0) && (self.stepCreateStep.on) && (self.step.text > 0)){
             NSString *text = @"y ";
            text = [text stringByAppendingString:self.step.text];
            text = [text stringByAppendingString:@" "];
            [parameters addObject:text];
        }else{
            [parameters addObject:@""];
        }
        
       if((self.ratioCalcSmoothingWindowSize.text.length > 0) && (self.ratioCalcSmoothingMinimumStep.text.length > 0) && ( [self.ratioCalcSmoothingWindowSize.text intValue] > 0)){
           NSString *text = self.ratioCalcSmoothingWindowSize.text;
           text = [text stringByAppendingString:@" "];
           if (self.ratioCalcSmoothingSmoothType.on){
               text = [text stringByAppendingString:@"1"];
           }else{
               text = [text stringByAppendingString:@"0"];
           }
           text = [text stringByAppendingString:@" "];
           text = [text stringByAppendingString:self.ratioCalcSmoothingMinimumStep.text];
           text = [text stringByAppendingString:@" "];
           if (self.ratioCalcSmoothingPrintMean.on){
               text = [text stringByAppendingString:@"1"];
           }else{
               text = [text stringByAppendingString:@"0"];
           }
           text = [text stringByAppendingString:@" "];
           if (self.ratioCalcSmoothingPrintZeros.on){
               text = [text stringByAppendingString:@"1"];
           }else{
               text = [text stringByAppendingString:@"0"];
           }
           [parameters addObject:text];
        }
        else{
            [parameters addObject:@""];
        }
        
        [self createExperimentFiles];
        for(NSMutableDictionary *dict in _experimentFilesDictArr){
            [dict setObject:parameters forKey:@"parameters"];
            [ServerConnection convert:dict withContext:self];
        }
        [XYZPopupGenerator showPopupWithMessage:@"Process sent to server"];
    }
    return;
    
}

- (void) reportResult: (NSError*) error {
    if(error){
        [XYZPopupGenerator showErrorMessage:error];
    }
}

-(void) createExperimentFiles{
    _experimentFilesDictArr = [[NSMutableArray alloc] init];
    for(XYZExperimentFile *file in _experimentFiles){
        NSMutableDictionary * currentFile =[[NSMutableDictionary alloc] init];
        [currentFile setObject:file.grVersion forKey:@"genomeVersion"];
        [currentFile setObject:file.expID forKey:@"expid"];
        [currentFile setObject:file.metaData forKey:@"metadata"];
        [currentFile setObject:file.author forKey:@"author"];
        [_experimentFilesDictArr addObject:currentFile];
    }
}

- (IBAction)samToGffChanged:(id)sender {
    if (self.samToGff.on) {
        self.gffToSgr.enabled = YES;
        self.gffToSgr.on = NO;
    } else {
        for(int i = 0; i < self.numpadFields.count; i++){
            UITextField *text = [self.numpadFields objectAtIndex:i];
            text.enabled=NO;
            text.text = @"";
        }
        for(int i = 1; i < self.switches.count; i++){
            UISwitch *switchen = [self.switches objectAtIndex:i];
            switchen.enabled = NO;
            switchen.on = NO;
        }
    }
}
- (IBAction)gffToSgrChanged:(id)sender {
    if (self.gffToSgr.on) {
        self.smoothingWindowSize.enabled = YES;
        self.smoothingSmoothTypeSwitch.enabled = YES;
        self.smoothingMinimumStep.enabled = YES;
        self.smoothingPrintMean.enabled = YES;
        self.smoothingPrintZeros.enabled = YES;
    } else {
        for(int i = 0; i < self.numpadFields.count; i++){
            UITextField *text = [self.numpadFields objectAtIndex:i];
            text.enabled=NO;
            text.text = @"";
            
        }
        for(int i = 2; i < self.switches.count; i++){
            UISwitch *switchen = [self.switches objectAtIndex:i];
            switchen.enabled = NO;
            switchen.on = NO;
            
        }
        self.ratioCalcDoubleSingle.enabled = NO;
    }
}

@end
