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
@property UIButton *doneButton;

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
    _tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    _tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:_tapper];
    self.bowtie.delegate = self;
    self.genomeFile.delegate = self;
    self.genomeFile.enabled = NO;
    self.smoothingWindowSize.delegate = self;
    self.smoothingWindowSize.enabled = NO;
    self.smoothingSmoothTypeSwitch.enabled = NO;
    self.smoothingSmoothTypeSwitch.on = NO;
    self.smoothingMinimumStep.delegate = self;
    self.smoothingMinimumStep.enabled = NO;
    self.smoothingPrintMean.enabled = NO;
    self.smoothingPrintMean.on = NO;
    self.smoothingPrintZeros.enabled = NO;
    self.smoothingPrintZeros.on = NO;
    self.stepCreateStep.enabled = NO;
    self.stepCreateStep.on = NO;
    self.step.delegate = self;
    self.step.enabled = NO;
    self.ratioCalcDoubleSingle.enabled = NO;
    self.ratioCalcInputReads.delegate = self;
    self.ratioCalcInputReads.enabled = NO;
    self.ratioCalcChromosomes.delegate = self;
    self.ratioCalcChromosomes.enabled = NO;
    self.ratioCalcSmoothingWindowSize.delegate = self;
    self.ratioCalcSmoothingWindowSize.enabled = NO;
    self.ratioCalcSmoothingSmoothType.enabled = NO;
    self.ratioCalcSmoothingSmoothType.on = NO;
    self.ratioCalcSmoothingMinimumStep.delegate = self;
    self.ratioCalcSmoothingMinimumStep.enabled = NO;
    self.ratioCalcSmoothingPrintMean.enabled = NO;
    self.ratioCalcSmoothingPrintMean.on = NO;
    self.ratioCalcSmoothingPrintZeros.enabled = NO;
    self.ratioCalcSmoothingPrintZeros.on = NO;
 
    self.originalCenter = self.view.center;

    self.samToGff.enabled = NO;
    self.samToGff.on = NO;
    self.gffToSgr.enabled = NO;
    self.gffToSgr.on = NO;

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
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height-53, 104, 53);
    _doneButton.adjustsImageWhenHighlighted = NO;
    [_doneButton setImage:[UIImage imageNamed:@"NextButtonNumberPad.png"] forState:UIControlStateNormal];
    [_doneButton setImage:[UIImage imageNamed:@"NextButtonNumberPadClicked.png"] forState:UIControlStateHighlighted];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y);
    [UIView commitAnimations];
    [super touchesBegan:touches withEvent:event];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.smoothingWindowSize){
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    }
}
- (void)keyboardWillShow:(NSNotification *)note {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:3];
    _doneButton.hidden = NO;
    [[[[UIApplication sharedApplication] windows] objectAtIndex:1] addSubview:_doneButton];
    [UIView commitAnimations];

}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField.text.length == 0){
        if(textField == self.bowtie) {
            self.genomeFile.enabled = NO;
            self.genomeFile.text = @"";
            self.samToGff.enabled = NO;
            self.samToGff.on = NO;
            self.gffToSgr.enabled = NO;
            self.gffToSgr.on = NO;
            self.smoothingWindowSize.enabled = NO;
             self.smoothingWindowSize.text = @"";
            self.smoothingSmoothTypeSwitch.enabled = NO;
            self.smoothingSmoothTypeSwitch.on = NO;
            self.smoothingMinimumStep.enabled = NO;
            self.smoothingMinimumStep.text = @"";
            self.smoothingPrintMean.enabled = NO;
            self.smoothingPrintMean.on = NO;
            self.smoothingPrintZeros.enabled = NO;
            self.smoothingPrintZeros.on = NO;
            
            self.stepCreateStep.enabled = NO;
            self.stepCreateStep.on = NO;
            self.step.enabled = NO;
            self.step.text = @"";

            self.ratioCalcDoubleSingle.enabled = NO;
            self.ratioCalcInputReads.enabled = NO;
            self.ratioCalcInputReads.text = @"";
            self.ratioCalcChromosomes.enabled = NO;
            self.ratioCalcChromosomes.text = @"";
            
            self.ratioCalcSmoothingWindowSize.enabled = NO;
            self.ratioCalcSmoothingWindowSize.text = @"";
            self.ratioCalcSmoothingSmoothType.enabled = NO;
            self.ratioCalcSmoothingSmoothType.on = NO;
            self.ratioCalcSmoothingMinimumStep.enabled = NO;
            self.ratioCalcSmoothingMinimumStep.text = @"";
            self.ratioCalcSmoothingPrintMean.enabled = NO;
            self.ratioCalcSmoothingPrintMean.on = NO;
            self.ratioCalcSmoothingPrintZeros.enabled = NO;
            self.ratioCalcSmoothingPrintZeros.on = NO;
        
        } else if(textField == self.genomeFile) {
            self.samToGff.enabled = NO;
            self.samToGff.on = NO;
            self.gffToSgr.enabled = NO;
            self.gffToSgr.on = NO;
            self.smoothingWindowSize.enabled = NO;
            self.smoothingWindowSize.text = @"";
            self.smoothingSmoothTypeSwitch.enabled = NO;
            self.smoothingSmoothTypeSwitch.on = NO;
            self.smoothingMinimumStep.enabled = NO;
            self.smoothingMinimumStep.text = @"";
            self.smoothingPrintMean.enabled = NO;
            self.smoothingPrintMean.on = NO;
            self.smoothingPrintZeros.enabled = NO;
            self.smoothingPrintZeros.on = NO;
            
            self.stepCreateStep.enabled = NO;
            self.stepCreateStep.on = NO;
            self.step.enabled = NO;
            self.step.text = @"";
            
            self.ratioCalcDoubleSingle.enabled = NO;
            self.ratioCalcInputReads.enabled = NO;
            self.ratioCalcInputReads.text = @"";
            self.ratioCalcChromosomes.enabled = NO;
            self.ratioCalcChromosomes.text = @"";
            
            self.ratioCalcSmoothingWindowSize.enabled = NO;
            self.ratioCalcSmoothingWindowSize.text = @"";
            self.ratioCalcSmoothingSmoothType.enabled = NO;
            self.ratioCalcSmoothingSmoothType.on = NO;
            self.ratioCalcSmoothingMinimumStep.enabled = NO;
            self.ratioCalcSmoothingMinimumStep.text = @"";
            self.ratioCalcSmoothingPrintMean.enabled = NO;
            self.ratioCalcSmoothingPrintMean.on = NO;
            self.ratioCalcSmoothingPrintZeros.enabled = NO;
            self.ratioCalcSmoothingPrintZeros.on = NO;
        
        }else if((textField == self.smoothingMinimumStep || textField == self.smoothingWindowSize) && ((self.smoothingWindowSize.text.length == 0) || (self.smoothingMinimumStep.text.length == 0) || (!self.smoothingPrintMean.enabled) || (!self.smoothingPrintZeros.enabled) || (!self.smoothingSmoothTypeSwitch.enabled))) {
        
            self.stepCreateStep.enabled = NO;
            self.stepCreateStep.on = NO;
            self.step.enabled = NO;
            self.step.text = @"";
            
            self.ratioCalcDoubleSingle.enabled = NO;
            self.ratioCalcInputReads.enabled = NO;
            self.ratioCalcInputReads.text = @"";
            self.ratioCalcChromosomes.enabled = NO;
            self.ratioCalcChromosomes.text = @"";
            
            self.ratioCalcSmoothingWindowSize.enabled = NO;
            self.ratioCalcSmoothingWindowSize.text = @"";
            self.ratioCalcSmoothingSmoothType.enabled = NO;
            self.ratioCalcSmoothingSmoothType.on = NO;
            self.ratioCalcSmoothingMinimumStep.enabled = NO;
            self.ratioCalcSmoothingMinimumStep.text = @"";
            self.ratioCalcSmoothingPrintMean.enabled = NO;
            self.ratioCalcSmoothingPrintMean.on = NO;
            self.ratioCalcSmoothingPrintZeros.enabled = NO;
            self.ratioCalcSmoothingPrintZeros.on = NO;
        }
        else if(textField == self.step) {
            self.ratioCalcDoubleSingle.enabled = NO;
            self.ratioCalcInputReads.enabled = NO;
            self.ratioCalcInputReads.text = @"";
            self.ratioCalcChromosomes.enabled = NO;
            self.ratioCalcChromosomes.text = @"";
            
            self.ratioCalcSmoothingWindowSize.enabled = NO;
            self.ratioCalcSmoothingWindowSize.text = @"";
            self.ratioCalcSmoothingSmoothType.enabled = NO;
            self.ratioCalcSmoothingSmoothType.on = NO;
            self.ratioCalcSmoothingMinimumStep.enabled = NO;
            self.ratioCalcSmoothingMinimumStep.text = @"";
            self.ratioCalcSmoothingPrintMean.enabled = NO;
            self.ratioCalcSmoothingPrintMean.on = NO;
            self.ratioCalcSmoothingPrintZeros.enabled = NO;
            self.ratioCalcSmoothingPrintZeros.on = NO;
        }
        else if((textField == self.ratioCalcInputReads || textField == self.ratioCalcChromosomes) && ((self.ratioCalcInputReads.text.length == 0) || (self.ratioCalcChromosomes.text.length == 0))) {
            
            self.ratioCalcSmoothingWindowSize.enabled = NO;
            self.ratioCalcSmoothingWindowSize.text = @"";
            self.ratioCalcSmoothingSmoothType.enabled = NO;
            self.ratioCalcSmoothingSmoothType.on = NO;
            self.ratioCalcSmoothingMinimumStep.enabled = NO;
            self.ratioCalcSmoothingMinimumStep.text = @"";
            self.ratioCalcSmoothingPrintMean.enabled = NO;
            self.ratioCalcSmoothingPrintMean.on = NO;
            self.ratioCalcSmoothingPrintZeros.enabled = NO;
            self.ratioCalcSmoothingPrintZeros.on = NO;
        }
    } else{
        if(textField == self.smoothingWindowSize){
            NSLog(@"saddsad");
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
        }
    }
    _doneButton.hidden = YES;

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
if(textField.text.length > 0 ){
    if(textField == self.bowtie) {
        self.genomeFile.enabled = YES;
        [self.genomeFile becomeFirstResponder];

    } else if(textField == self.genomeFile) {
        self.samToGff.enabled = YES;
        [textField endEditing:YES];

    }else if(textField == self.smoothingWindowSize) {
        self.smoothingSmoothTypeSwitch.enabled = YES;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [textField endEditing:YES];
  
    }else if(textField == self.smoothingMinimumStep) {
        self.smoothingPrintMean.enabled = YES;
        [textField endEditing:YES];
        
    }else if(textField == self.step) {
        if(_ratio){
            self.ratioCalcDoubleSingle.enabled = YES;
            [textField endEditing:YES];
        }else{
            [textField endEditing:YES];
            [self.tableView setContentOffset:CGPointMake(0, 25) animated:YES];
        }
    }else if(textField == self.ratioCalcInputReads) {
        self.ratioCalcChromosomes.enabled = YES;
        [self.ratioCalcChromosomes becomeFirstResponder];
    
    }else if(textField == self.ratioCalcChromosomes) {
        self.ratioCalcSmoothingWindowSize.enabled = YES;
        [self.ratioCalcSmoothingWindowSize becomeFirstResponder];
    }else if(textField == self.ratioCalcSmoothingWindowSize) {
        self.ratioCalcSmoothingSmoothType.enabled = YES;
        [textField endEditing:YES];
    }else if(textField == self.ratioCalcSmoothingMinimumStep) {
        self.ratioCalcSmoothingPrintMean.enabled = YES;
        [textField endEditing:YES];
    }
}
return NO;
}

- (IBAction)convertButtonTouch:(id)sender
{
 /*   if(_bowtie.text.length == 0){
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
        [parameters addObject:_smoothing.text];
        [parameters addObject:_step.text];
        if((_ratioCalc.text.length > 0) && (_ratioCalcSmoothing.text.length > 0)){
            [parameters addObject:_ratioCalc.text];
            [parameters addObject:_ratioCalcSmoothing.text];
        }
        else{
            [parameters addObject:@""];
            [parameters addObject:@""];
        }
        
        [self createExperimentFiles];
        for(NSMutableDictionary *dict in _experimentFilesDictArr){
            [dict setObject:parameters forKey:@"parameters"];
            [ServerConnection convert:dict withContext:self];
        }
        for(XYZExperimentFile *file in _experimentFiles){
            [ProcessViewController addProcessingExperiment:file];
        }
        [XYZPopupGenerator showPopupWithMessage:@"Process sent to server"];
    }*/
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
    //    [currentFile setObject:file.name forKey:@"filename"];
    //    [currentFile setObject:file.idFile forKey:@"fileId"];
        [currentFile setObject:file.expID forKey:@"expid"];
        [currentFile setObject:@"rawtoprofile" forKey:@"processtype"];
        [currentFile setObject:file.metaData forKey:@"metadata"];
        [currentFile setObject:file.grVersion forKey:@"genomeRelease"];
        [currentFile setObject:file.author forKey:@"author"];
        NSLog(@"currfile%@", currentFile);
        [_experimentFilesDictArr addObject:currentFile];
    }
}

- (IBAction)samToGffChanged:(id)sender {
    if (self.samToGff.on) {
        self.gffToSgr.enabled = YES;
        self.gffToSgr.on = NO;
    } else {
        self.gffToSgr.enabled = NO;
        self.gffToSgr.on = NO;
        self.smoothingWindowSize.enabled = NO;
        self.smoothingSmoothTypeSwitch.enabled = NO;
        self.smoothingSmoothTypeSwitch.on = NO;
        self.smoothingMinimumStep.enabled = NO;
        self.smoothingPrintMean.enabled = NO;
        self.smoothingPrintMean.on = NO;
        self.smoothingPrintZeros.enabled = NO;
        self.smoothingPrintZeros.on = NO;
        
        self.stepCreateStep.enabled = NO;
        self.stepCreateStep.on = NO;
        self.step.enabled = NO;
        
        self.ratioCalcDoubleSingle.enabled = NO;
        self.ratioCalcInputReads.enabled = NO;
        self.ratioCalcChromosomes.enabled = NO;
        
        self.ratioCalcSmoothingWindowSize.enabled = NO;
        self.ratioCalcSmoothingSmoothType.enabled = NO;
        self.ratioCalcSmoothingSmoothType.on = NO;
        self.ratioCalcSmoothingMinimumStep.enabled = NO;
        self.ratioCalcSmoothingPrintMean.enabled = NO;
        self.ratioCalcSmoothingPrintMean.on = NO;
        self.ratioCalcSmoothingPrintZeros.enabled = NO;
        self.ratioCalcSmoothingPrintZeros.on = NO;
    }
}
- (IBAction)gffToSgrChanged:(id)sender {
    if (self.gffToSgr.on) {
        self.smoothingWindowSize.enabled = YES;
    } else {
        self.smoothingWindowSize.enabled = NO;
        self.smoothingSmoothTypeSwitch.enabled = NO;
        self.smoothingSmoothTypeSwitch.on = NO;
        self.smoothingMinimumStep.enabled = NO;
        self.smoothingPrintMean.enabled = NO;
        self.smoothingPrintMean.on = NO;
        self.smoothingPrintZeros.enabled = NO;
        self.smoothingPrintZeros.on = NO;
        
        self.stepCreateStep.enabled = NO;
        self.stepCreateStep.on = NO;
        self.step.enabled = NO;
        
        self.ratioCalcDoubleSingle.enabled = NO;
        self.ratioCalcInputReads.enabled = NO;
        self.ratioCalcChromosomes.enabled = NO;
        
        self.ratioCalcSmoothingWindowSize.enabled = NO;
        self.ratioCalcSmoothingSmoothType.enabled = NO;
        self.ratioCalcSmoothingSmoothType.on = NO;
        self.ratioCalcSmoothingMinimumStep.enabled = NO;
        self.ratioCalcSmoothingPrintMean.enabled = NO;
        self.ratioCalcSmoothingPrintMean.on = NO;
        self.ratioCalcSmoothingPrintZeros.enabled = NO;
        self.ratioCalcSmoothingPrintZeros.on = NO;
    }
}
- (IBAction)smoothTypeSwitchChanged:(id)sender {
    if (self.smoothingSmoothTypeSwitch.on) {
        self.smoothingMinimumStep.enabled = YES;
    } else {
        self.smoothingMinimumStep.enabled = NO;
        self.smoothingPrintMean.enabled = NO;
        self.smoothingPrintMean.on = NO;
        self.smoothingPrintZeros.enabled = NO;
        self.smoothingPrintZeros.on = NO;
        
        self.stepCreateStep.enabled = NO;
        self.stepCreateStep.on = NO;
        self.step.enabled = NO;
        
        self.ratioCalcDoubleSingle.enabled = NO;
        self.ratioCalcInputReads.enabled = NO;
        self.ratioCalcChromosomes.enabled = NO;
        
        self.ratioCalcSmoothingWindowSize.enabled = NO;
        self.ratioCalcSmoothingSmoothType.enabled = NO;
        self.ratioCalcSmoothingSmoothType.on = NO;
        self.ratioCalcSmoothingMinimumStep.enabled = NO;
        self.ratioCalcSmoothingPrintMean.enabled = NO;
        self.ratioCalcSmoothingPrintMean.on = NO;
        self.ratioCalcSmoothingPrintZeros.enabled = NO;
        self.ratioCalcSmoothingPrintZeros.on = NO;
    }
}
- (IBAction)smoothPrintMeanSwitchChanged:(id)sender {
    if (self.smoothingPrintMean.on) {
        self.smoothingPrintZeros.enabled = YES;
    } else {
        self.smoothingPrintZeros.enabled = NO;
        self.smoothingPrintZeros.on = NO;
        
        self.stepCreateStep.enabled = NO;
        self.stepCreateStep.on = NO;
        self.step.enabled = NO;
        
        self.ratioCalcDoubleSingle.enabled = NO;
        self.ratioCalcInputReads.enabled = NO;
        self.ratioCalcChromosomes.enabled = NO;
        
        self.ratioCalcSmoothingWindowSize.enabled = NO;
        self.ratioCalcSmoothingSmoothType.enabled = NO;
        self.ratioCalcSmoothingSmoothType.on = NO;
        self.ratioCalcSmoothingMinimumStep.enabled = NO;
        self.ratioCalcSmoothingPrintMean.enabled = NO;
        self.ratioCalcSmoothingPrintMean.on = NO;
        self.ratioCalcSmoothingPrintZeros.enabled = NO;
        self.ratioCalcSmoothingPrintZeros.on = NO;
    }
}
- (IBAction)smoothPrintZerosSwitchChanged:(id)sender {
    if (self.smoothingPrintZeros.on) {
        self.stepCreateStep.enabled = YES;
    } else {
        self.stepCreateStep.enabled = NO;
        self.stepCreateStep.on = NO;
        self.step.enabled = NO;
        
        self.ratioCalcDoubleSingle.enabled = NO;
        self.ratioCalcInputReads.enabled = NO;
        self.ratioCalcChromosomes.enabled = NO;
        
        self.ratioCalcSmoothingWindowSize.enabled = NO;
        self.ratioCalcSmoothingSmoothType.enabled = NO;
        self.ratioCalcSmoothingSmoothType.on = NO;
        self.ratioCalcSmoothingMinimumStep.enabled = NO;
        self.ratioCalcSmoothingPrintMean.enabled = NO;
        self.ratioCalcSmoothingPrintMean.on = NO;
        self.ratioCalcSmoothingPrintZeros.enabled = NO;
        self.ratioCalcSmoothingPrintZeros.on = NO;
    }
}
- (IBAction)stepCreateStepChanged:(id)sender {
    if (self.stepCreateStep.on) {
        self.step.enabled = YES;
    } else {
        self.step.enabled = NO;
        
        self.ratioCalcDoubleSingle.enabled = NO;
        self.ratioCalcInputReads.enabled = NO;
        self.ratioCalcChromosomes.enabled = NO;
        
        self.ratioCalcSmoothingWindowSize.enabled = NO;
        self.ratioCalcSmoothingSmoothType.enabled = NO;
        self.ratioCalcSmoothingSmoothType.on = NO;
        self.ratioCalcSmoothingMinimumStep.enabled = NO;
        self.ratioCalcSmoothingPrintMean.enabled = NO;
        self.ratioCalcSmoothingPrintMean.on = NO;
        self.ratioCalcSmoothingPrintZeros.enabled = NO;
        self.ratioCalcSmoothingPrintZeros.on = NO;
    }
}
/*- (IBAction)ratioSingleDoubleChanged:(id)sender {
    if (self.ratioCalcDoubleSingle.on) {
        self.ratioCalcInputReads.enabled;
    } else {
        self.ratioCalcInputReads.enabled = NO;
        self.ratioCalcChromosomes.enabled = NO;
        
        self.ratioCalcSmoothingWindowSize.enabled = NO;
        self.ratioCalcSmoothingSmoothType.enabled = NO;
        self.ratioCalcSmoothingSmoothType.on = NO;
        self.ratioCalcSmoothingMinimumStep.enabled = NO;
        self.ratioCalcSmoothingPrintMean.enabled = NO;
        self.ratioCalcSmoothingPrintMean.on = NO;
        self.ratioCalcSmoothingPrintZeros.enabled = NO;
        self.ratioCalcSmoothingPrintZeros.on = NO;
    }
}*/
- (IBAction)ratioCalcSmoothSmoothTypeChanged:(id)sender {
    if (self.ratioCalcSmoothingSmoothType.on) {
        self.ratioCalcSmoothingMinimumStep.enabled = YES;
    } else {
        self.ratioCalcSmoothingMinimumStep.enabled = NO;
        self.ratioCalcSmoothingPrintMean.enabled = NO;
        self.ratioCalcSmoothingPrintMean.on = NO;
        self.ratioCalcSmoothingPrintZeros.enabled = NO;
        self.ratioCalcSmoothingPrintZeros.on = NO;
    }
}
- (IBAction)ratioSmoothPrintMean:(id)sender {
    if (self.ratioCalcSmoothingPrintMean.on) {
        self.ratioCalcSmoothingPrintZeros.enabled = YES;
    } else {
        self.ratioCalcSmoothingPrintZeros.enabled = NO;
        self.ratioCalcSmoothingPrintZeros.on = NO;
    }
}
- (IBAction)ratioSmoothPrintZeros:(id)sender {
    [self.tableView setContentOffset:CGPointMake(0, 140) animated:YES];
}


@end
