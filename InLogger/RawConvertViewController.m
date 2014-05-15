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
@property (weak, nonatomic) IBOutlet UITextField *smoothing;
@property (weak, nonatomic) IBOutlet UITextField *step;
@property (weak, nonatomic) IBOutlet UISwitch *samToGff;
@property (weak, nonatomic) IBOutlet UISwitch *gffToSgr;
@property (weak, nonatomic) IBOutlet UITextField *ratioCalc;
@property (weak, nonatomic) IBOutlet UITextField *ratioCalcSmoothing;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableViewCell *ratioCalcCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *ratioCalcSmoothingCell;




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
    self.smoothing.delegate = self;
    self.step.delegate = self;
    self.ratioCalc.delegate = self;
    self.ratioCalcSmoothing.delegate = self;
    self.originalCenter = self.view.center;
    self.genomeFile.enabled = NO;
    self.samToGff.enabled = NO;
    self.samToGff.on = NO;
    self.gffToSgr.enabled = NO;
    self.gffToSgr.on = NO;
    self.smoothing.enabled = NO;
    self.step.enabled = NO;
    self.ratioCalc.enabled = NO;
    self.ratioCalcSmoothing.enabled = NO;
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length == 0){
        if(textField == self.bowtie) {
            self.genomeFile.enabled = NO;
            self.genomeFile.text = @"";
            self.smoothing.enabled = NO;
            self.smoothing.text = @"";
            self.samToGff.enabled = NO;
            self.samToGff.on = NO;
            self.gffToSgr.enabled = NO;
            self.gffToSgr.on = NO;
            self.step.enabled = NO;
            self.step.text = @"";
            self.ratioCalc.enabled = NO;
            self.ratioCalc.text = @"";
            self.ratioCalcSmoothing.enabled = NO;
            self.ratioCalcSmoothing.text = @"";
        
        } else if(textField == self.genomeFile) {
            self.smoothing.enabled = NO;
            self.smoothing.text = @"";
            self.samToGff.enabled = NO;
            self.samToGff.on = NO;
            self.gffToSgr.enabled = NO;
            self.gffToSgr.on = NO;
            self.step.enabled = NO;
            self.step.text = @"";
            self.ratioCalc.enabled = NO;
            self.ratioCalc.text = @"";
            self.ratioCalcSmoothing.enabled = NO;
            self.ratioCalcSmoothing.text = @"";
        
        }else if(textField == self.smoothing) {
        
            self.samToGff.enabled = NO;
            self.samToGff.on = NO;
            self.gffToSgr.enabled = NO;
            self.gffToSgr.on = NO;
            self.step.enabled = NO;
            self.step.text = @"";
            self.ratioCalc.enabled = NO;
            self.ratioCalc.text = @"";
            self.ratioCalcSmoothing.enabled = NO;
            self.ratioCalcSmoothing.text = @"";
        }
        else if(textField == self.step) {
            self.ratioCalc.enabled = NO;
            self.ratioCalc.text = @"";
            self.ratioCalcSmoothing.enabled = NO;
            self.ratioCalcSmoothing.text = @"";
        }
        else if(_ratio && (textField == self.ratioCalc)) {
        
            self.ratioCalcSmoothing.enabled = NO;
            self.ratioCalcSmoothing.text = @"";
        }
    }

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
if(textField.text.length > 0 ){
    if(textField == self.bowtie) {
        self.genomeFile.enabled = YES;
        [self.genomeFile becomeFirstResponder];

    } else if(textField == self.genomeFile) {
        self.samToGff.enabled = YES;
        self.samToGff.on = NO;
        [textField endEditing:YES];

    }else if(textField == self.smoothing) {
        self.step.enabled = YES;
        [self.step becomeFirstResponder];
  
    }else if(textField == self.step) {
        if(_ratio){
            self.ratioCalc.enabled = YES;
            [self.ratioCalc becomeFirstResponder];

        }else{
            [textField endEditing:YES];
            [self.tableView setContentOffset:CGPointMake(0, 25) animated:YES];
        }
    }else if(textField == self.ratioCalc) {
        self.ratioCalcSmoothing.enabled = YES;
        [self.ratioCalcSmoothing becomeFirstResponder];
    
    }else if(textField == self.ratioCalcSmoothing) {
        [textField endEditing:YES];
        [self.tableView setContentOffset:CGPointMake(0, 140) animated:YES];
      //  [self.tableView setContentOffset:CGPointZero animated:YES];
    }
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
        
        NSError *error;
        
        [self createExperimentFiles];
        for(NSMutableDictionary *dict in _experimentFilesDictArr){
            [dict setObject:parameters forKey:@"parameters"];
            [ServerConnection convert:dict error:&error];
            if(error){
                [self showErrorMessage:[error.userInfo objectForKey:NSLocalizedDescriptionKey] title:error.domain];
                
            }
        }
        for(XYZExperimentFile *file in _experimentFiles){
            [ProcessViewController addProcessingExperiment:file];
        }
        [XYZPopupGenerator showPopupWithMessage:@"Process sent to server"];
    }
    return;
    
}
-(void) createExperimentFiles{
    _experimentFilesDictArr = [[NSMutableArray alloc] init];
    for(XYZExperimentFile *file in _experimentFiles){
        NSMutableDictionary * currentFile =[[NSMutableDictionary alloc] init];
        [currentFile setObject:file.name forKey:@"filename"];
        [currentFile setObject:file.idFile forKey:@"fileId"];
        [currentFile setObject:file.expID forKey:@"expid"];
        [currentFile setObject:@"rawtoprofile" forKey:@"processtype"];
        [currentFile setObject:file.metaData forKey:@"metadata"];
        [currentFile setObject:file.grVersion forKey:@"genomeRelease"];
        [currentFile setObject:file.author forKey:@"author"];
        NSLog(@"currfile%@", currentFile);
        [_experimentFilesDictArr addObject:currentFile];
    }
}

- (IBAction)showErrorMessage:(NSString*) error title:(NSString*)title
{
    UIAlertView *convertMessage = [[UIAlertView alloc]
                                initWithTitle:title message:error
                                delegate:nil cancelButtonTitle:@"Try again"
                                otherButtonTitles:nil];
        
    [convertMessage show];
}

- (IBAction)samToGffChanged:(id)sender {
    if (self.samToGff.on) {
        self.gffToSgr.enabled = YES;
        self.gffToSgr.on = NO;
    } else {
        self.gffToSgr.on = NO;
        self.gffToSgr.enabled = NO;
        self.smoothing.enabled = NO;
        self.step.enabled = NO;
        self.ratioCalc.enabled = NO;
        self.ratioCalcSmoothing.enabled = NO;
    }
}
- (IBAction)gffToSgrChanged:(id)sender {
    if (self.gffToSgr.on) {
        self.smoothing.enabled = YES;
    } else {
        self.smoothing.enabled = NO;
        self.step.enabled = NO;
        self.ratioCalc.enabled = NO;
        self.ratioCalcSmoothing.enabled = NO;
    }
}

@end
