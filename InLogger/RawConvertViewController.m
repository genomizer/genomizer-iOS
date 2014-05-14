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

@interface RawConvertViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bowtie;
@property (weak, nonatomic) IBOutlet UITextField *genomeFile;
@property (weak, nonatomic) IBOutlet UITextField *smoothing;
@property (weak, nonatomic) IBOutlet UITextField *step;
@property (weak, nonatomic) IBOutlet UISwitch *samToGff;
@property (weak, nonatomic) IBOutlet UISwitch *gffToSgr;
@property (weak, nonatomic) IBOutlet UITextField *ratioCalc;
@property (weak, nonatomic) IBOutlet UITextField *ratioCalcSmoothing;

@property CGPoint originalCenter;
@property NSMutableArray *experimentFilesDictArr;



@end

@implementation RawConvertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bowtie.delegate = self;
    self.genomeFile.delegate = self;
    self.smoothing.delegate = self;
    self.step.delegate = self;
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)centerFrameView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
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
    if(textField == self.bowtie) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-0);
        [UIView commitAnimations];
    
    } else if(textField == self.genomeFile) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-25);
        [UIView commitAnimations];
  
    }else if(textField == self.smoothing) {

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-40);
        [UIView commitAnimations];
    }
    else if(textField == self.step) {

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-55);
        [UIView commitAnimations];
    }
    else if(textField == self.ratioCalc) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-70);
        [UIView commitAnimations];
    }
    else if(textField == self.ratioCalcSmoothing) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-85);
        [UIView commitAnimations];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.bowtie) {
        self.genomeFile.enabled = YES;
        [self.genomeFile becomeFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-20);
        [UIView commitAnimations];
       // [self centerFrameView];
    } else if(textField == self.genomeFile) {
         self.samToGff.enabled = YES;
        self.samToGff.on = NO;
        [textField endEditing:YES];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
              self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-35);
        [UIView commitAnimations];
       
       // [self centerFrameView];
    }else if(textField == self.smoothing) {
        self.step.enabled = YES;
        [self.step becomeFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-80);
        [UIView commitAnimations];
  
    }
    else if(textField == self.step) {
         self.ratioCalc.enabled = YES;
        [self.ratioCalc becomeFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-140);
        NSLog(@"KUUUUUUUK");
        [UIView commitAnimations];
    }
    else if(textField == self.ratioCalc) {
        NSLog(@"KUUUUUUUK");
        self.ratioCalcSmoothing.enabled = YES;
        [self.ratioCalcSmoothing becomeFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-170);
        [UIView commitAnimations];
    }
    else if(textField == self.ratioCalcSmoothing) {
        [textField endEditing:YES];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y);
        [UIView commitAnimations];
    }
return NO;
}
- (IBAction)ConvertButtonPressed:(id)sender {
    NSMutableArray * parameters = [[NSMutableArray alloc] init];
    [parameters addObject:_bowtie.text];
    [parameters addObject:_genomeFile.text];
    [parameters addObject:_smoothing.text];
    [parameters addObject:_step.text];
    NSError *error;

    [self createExperimentFiles];
    for(NSMutableDictionary *dict in _experimentFilesDictArr){
        [dict setObject:parameters forKey:@"parameters"];
        [ServerConnection convert:dict error:&error];
        if(error){
            [self showErrorMessage:[error.userInfo objectForKey:NSLocalizedDescriptionKey] title:error.domain];

        }
    }
    [XYZPopupGenerator showPopupWithMessage:@"Not yet implemented!"];
    return;
    /*UIAlertView *convertDoneMessage = [[UIAlertView alloc]
                                   initWithTitle:@"Convert request" message:@"Convert request sent successfully to server"
                                   delegate:nil cancelButtonTitle:@"Done"
                                   otherButtonTitles:nil];
    
    [convertDoneMessage show];*/
    
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
