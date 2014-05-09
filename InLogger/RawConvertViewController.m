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

@interface RawConvertViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bowtie;
@property (weak, nonatomic) IBOutlet UITextField *genomeFile;
@property (weak, nonatomic) IBOutlet UITextField *smoothing;
@property (weak, nonatomic) IBOutlet UITextField *step;
@property (weak, nonatomic) IBOutlet UISwitch *bowtieSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *genomeFileSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *smoothingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *stepSwitch;
@property CGPoint originalCenter;


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
    NSLog(@"files %@", _experimentFiles[0]);
    
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

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"sdafghjk");
    if(textField == self.bowtie) {
        [self.genomeFile becomeFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-20);
        [UIView commitAnimations];
       // [self centerFrameView];
    } else if(textField == self.genomeFile) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
              self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-35);
        [UIView commitAnimations];
        [self.smoothing becomeFirstResponder];
       // [self centerFrameView];
    }else if(textField == self.smoothing) {
        [self.step becomeFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
                self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-50);
        [UIView commitAnimations];
    }
    else if(textField == self.step) {
    [textField endEditing:YES];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y);
        [UIView commitAnimations];
        //  [self centerFrameView];
   
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

    for(NSMutableDictionary *dict in _experimentFiles){
        [dict setObject:parameters forKey:@"parameters"];
        [ServerConnection convert:dict error:&error];
        if(error){
            [self showErrorMessage:[error.userInfo objectForKey:NSLocalizedDescriptionKey] title:error.domain];

        }
    }
     [self showErrorMessage:@"Convert request sent succuessfully to server" title:@"Convert request"];
}
- (IBAction)showErrorMessage:(NSString*) error title:(NSString*)title
{
    UIAlertView *convertMessage = [[UIAlertView alloc]
                                initWithTitle:title message:error
                                delegate:nil cancelButtonTitle:@"Try again"
                                otherButtonTitles:nil];
        
    [convertMessage show];
}
    
    
    



@end
