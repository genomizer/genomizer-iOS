//
//  RawConvertViewController.m
//  Genomizer
//
//  This class makes a convertrequest from data specified by the user and
//  converts the files that was selected by the user in the searchResult or
//  selectedfiles -view from raw to profile. Uses the method convert in
//  serverConnection to send the request to the server.
//

#import "RawConvertViewController.h"
#import "ExperimentFile.h"
#import "ServerConnection.h"
#import "PopupGenerator.h"
#import <QuartzCore/QuartzCore.h>
#import "ProcessViewController.h"
#import "Reachability.h"
#import "TabViewController.h"

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

@property UIPickerView *pickerView;
@property UIToolbar *toolBar;
@property NSMutableArray* genomeReleases;
@property UIButton *convertButton;
@property UIActivityIndicatorView *activityIndicator;


@end

@implementation RawConvertViewController{
    __weak UIView *_staticView;
    int numberOfConvertRequestsLeftToConfirm;
    int successfulConvertRequests;
}

@synthesize tableView;
//@synthesize completionBlock;
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Get genomereleases that are used as datasource for the pickerView.
    [ServerConnection genomeRelease:^(NSMutableArray *ma, NSError *e){
        [self reportGenomeResult:ma withError:e];
    }];
    _pickerView = [self createPickerView];
    _toolBar = [self createPickerViewToolBar:_pickerView];
    //set up all textfields and switchbuttons.
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
    self.ratioCalcDoubleSingle.enabled = NO;
    [self.view addGestureRecognizer:_tapper];
    self.bowtie.delegate = self;
    self.genomeFile.delegate = self;
    self.genomeFile.enabled = YES;
    self.genomeFile.inputView = _pickerView;
    self.genomeFile.inputAccessoryView = _toolBar;
    self.samToGff.enabled = YES;
    _pickerView.delegate = (id)self;
    _pickerView.dataSource = (id)self;
    self.originalCenter = self.view.center;
    if(_ratio){
        _ratioCalcCell.hidden = NO;
        _ratioCalcSmoothingCell.hidden = NO;
    }

    /**
      * Create frame containing the convert button.
      */
    float buttonHeight = 56;
    UIView *staticView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bounds.size.height-buttonHeight, self.tableView.bounds.size.width, buttonHeight)];
    staticView.backgroundColor = [UIColor colorWithRed:74/255.f green:144/255.f blue:226/255.f alpha:1.0];
    _convertButton=[UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    [_convertButton setTitle:@"Convert" forState:UIControlStateNormal];
    _convertButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.f];
    [_convertButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_convertButton addTarget:self action:@selector(convertButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    _convertButton.frame=staticView.bounds;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.frame=CGRectMake(self.tableView.bounds.size.width/2-65, 10, 130, 30);
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.hidden = YES;
    
    [staticView addSubview:_activityIndicator];
    [staticView addSubview:_convertButton];
    
    [_activityIndicator stopAnimating];
    
    [self.tableView addSubview:staticView];
    _staticView = staticView;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, buttonHeight, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}


-(IBAction)popViewController:(id)sender{
    [self dismissViewControllerAnimated:true completion:nil];
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    // Returns number of sections in pickerview.
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns number of rows in pickerview.
    return [_genomeReleases count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //returns title for object at specific row in pickerview.
    return [_genomeReleases objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    self.genomeFile.text = [_genomeReleases objectAtIndex:row];
    
}

/**
 * Method that creates a toolbar in pickerview containg a done-button.
 */
- (UIToolbar *) createPickerViewToolBar: (UIPickerView *) pickerView
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, pickerView.bounds.size.width, 44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    [toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    return toolBar;
}
/**
 * Method that creates and reutrns a pickerview.
 */
- (UIPickerView *) createPickerView
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 44, 44)];
    pickerView.backgroundColor = [UIColor colorWithRed:247.0/255.0f green:248.0/255.0f
                                                  blue:247.0/255 alpha:1.0f];
    pickerView.showsSelectionIndicator = YES;
    [pickerView setAccessibilityLabel:@"PickerView"];
    return pickerView;
}

/**
 * Executes when the "done"-button in pickerviews toolbar is pressed.
 */
-(void)doneTouched:(UIBarButtonItem*)sender
{
    [self.view endEditing:YES];
    [self.tableView reloadData];
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
}
/**
 * Executes when a textfield have ended editing.
 * Does some cheking to see what fields should be de/activated depending on
 * what fields contains text.
 */
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
            self.ratioCalcDoubleSingle.enabled = NO;
            
        } else if(textField == self.genomeFile) {
            for(UITextField *text in self.numpadFields){
                text.enabled = NO;
                text.text=@"";
            }
            for(UISwitch *switches in self.switches){
                switches.enabled = NO;
                switches.on = NO;
            }
            self.ratioCalcDoubleSingle.enabled = NO;
            
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
            self.ratioCalcDoubleSingle.enabled = NO;
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
            self.ratioCalcDoubleSingle.enabled = NO;
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
        if(textField == self.genomeFile) {
            self.samToGff.enabled = YES;
        }
        else if(((textField == self.smoothingWindowSize) || (textField == self.smoothingMinimumStep)) && (self.smoothingWindowSize.text.length > 0) && (self.smoothingMinimumStep.text.length > 0)) {
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
/**
 * Method that describes what should happen when the next button on the keyboard is
 * pressed.
 */
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

/**
 * Method that executes when the convert-button is pressed.
 * Creates a NSMutableArray that are filled with datainput from the user,
 * the userinput are converted to a form that matches the form the server are 
 * excpecting.
 * @return calls the serverConnections convert-method with the data that are
 *          going to be sent to the server.
 */
- (IBAction)convertButtonTouch:(id)sender
{
    
    if((_bowtie.text.length == 0) || (_genomeFile.text.length == 0)){
        [(TabBar2Controller *)self.tabBar2Controller showPopDownWithTitle:@"Not enough information" andMessage:@"Fill in at least the fields \"Bowtie parameters\" and \"Genome file\" to start a process" type:@"error"];
    }else{
        _convertButton.hidden = YES;
        [_activityIndicator startAnimating];
        NSMutableArray * parameters = [[NSMutableArray alloc] init];
        [parameters addObject:_bowtie.text];
        [parameters addObject:@""];
        
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

            int calcSmoothinSmooth = self.ratioCalcSmoothingSmoothType.on/* ? 1 : 0*/;
            int calcSmoothinMean = self.ratioCalcSmoothingPrintMean.on/* ? 1 : 0*/;
            int calcSmoothinZeros = self.ratioCalcSmoothingPrintZeros.on;
            text = [text stringByAppendingFormat:@" %d %@ %d %d", calcSmoothinSmooth, self.ratioCalcSmoothingMinimumStep.text, calcSmoothinMean, calcSmoothinZeros];
            
            [parameters addObject:text];
        }
        else{
            [parameters addObject:@""];
        }
    
        [self createExperimentFiles];
    
        numberOfConvertRequestsLeftToConfirm = 0;
        successfulConvertRequests = 0;
        for(NSMutableDictionary *dict in _experimentFilesDictArr){
            [dict setObject:parameters forKey:@"parameters"];
            NSString *metadata = @"";
            for (int i = 0; i < parameters.count; i++)
            {
                NSString *data = parameters[i];
                metadata = [metadata stringByAppendingString:data];
                if ((i + 1) < parameters.count)
                {
                    metadata = [metadata stringByAppendingString:@", "];
                }
            }
            [dict setObject:metadata forKey:@"metadata"];
            [dict setObject:_genomeFile.text forKey:@"genomeVersion"];
            [ServerConnection convert:dict withContext:^(NSError *e,
                                                         NSString *s){
                [self reportResult:e experiment:s];
            }];
            numberOfConvertRequestsLeftToConfirm++;
        }
    }
    return;

}

/**
 * Method that are called by serverConnection when a convert request have been 
 * sent to the server.
 * @param error - Contains information about any error that may have  occured.
 * @param expid - The experiment ID if the experiment that are going to be converted.
 * @return shows a popup with info abvout any error if such have occured.
 *         if no error a popup explaining to the user how many successfull request
 *         that was sent to the server.
 */
- (void) reportResult: (NSError*) error experiment: (NSString*) expid 
{
    dispatch_async(dispatch_get_main_queue(), ^{
        numberOfConvertRequestsLeftToConfirm--;
        
        if([error.domain isEqualToString:@"Connection Error"])
        {
            
            [PopupGenerator showErrorMessage:error];
            numberOfConvertRequestsLeftToConfirm = 0;
        }
        else if(error){
            NSDictionary *dictionary = error.userInfo;
            [dictionary setValue:([NSString stringWithFormat:@"Experiment %@ failed with error: %@", expid, error.localizedDescription]) forKey:@"localizedDescription"];
            [PopupGenerator showErrorMessage:[NSError errorWithDomain:error.domain code:error.code userInfo:dictionary]];
        }
        else
        {
            successfulConvertRequests++;
        }
        
        if(numberOfConvertRequestsLeftToConfirm == 0)
        {
            NSString *requestString = @"request";
            if(successfulConvertRequests > 0){
                if (successfulConvertRequests > 1){
                    requestString = [requestString stringByAppendingString:@"s"];
                }
          
                
                NSString *message = [NSString stringWithFormat:@"%d convert %@ successfully sent to the server.", successfulConvertRequests, requestString];
//                [PopupGenerator showPopupWithMessage:message withTitle:@"" withCancelButtonTitle:@"OK" withDelegate:self];
                [self dismissViewControllerAnimated:true completion:nil];
                [(TabBar2Controller *)self.tabBar2Controller showPopDownWithTitle:@"Convert sent" andMessage:message type:@"success"];
//                self.completionBlock(error, message);
            }
            _convertButton.enabled = YES;
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [_activityIndicator stopAnimating];
            _convertButton.hidden = NO;
            
        }
    });
}

/* popup delegate method */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * Method that are called by serverConnection when a genomerelease request are sent to 
 * the server.
 * @param genomeReleases - an array containing all genomereleases on the server.
 * @param error - Contains information about any error that may have  occured.
 * @return fills the pickerView with the genomereleases that was returned by the 
 *         genomeReleases request sent by serverConnection.
 */
- (void) reportGenomeResult:(NSMutableArray*) genomeReleases withError:(NSError*) error {
    if(error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [(TabBar2Controller *)self.tabBar2Controller showPopDownWithError:error];
        });
    }
    else
    {
        _genomeReleases = genomeReleases;
        if ([_pickerView selectedRowInComponent:0] == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_pickerView selectRow:0 inComponent:0 animated:NO];
                _genomeFile.text = _genomeReleases[[_pickerView selectedRowInComponent:0]];
            });
        }
    }
}

/**
 * Method that creates one experimentFile per experiment that are going to be converted.
 * Fills the experiment file with the data that are needed to send the convert request.
 */
-(void) createExperimentFiles
{
    NSMutableArray *expIdsAlreadyCreated = [[NSMutableArray alloc] init];
    _experimentFilesDictArr = [[NSMutableArray alloc] init];
    for(ExperimentFile *file in _experimentFiles){
        
        if(![expIdsAlreadyCreated containsObject:file.expID])
        {
            NSMutableDictionary *currentFile =[[NSMutableDictionary alloc] init];
            
            [currentFile setObject:file.expID forKey:@"expid"];
            [expIdsAlreadyCreated addObject:file.expID];
            [currentFile setObject:file.metaData forKey:@"metadata"];
            
            if(file.author != nil)
            {
                [currentFile setObject:file.author forKey:@"author"];
            }
            
            [_experimentFilesDictArr addObject:currentFile];
        } 
    }
}

/**
 * Executes when the switchbutton "samToGff" is changed.
 */
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

/**
 * Executes when the switchbutton "GffToSgr" is changed.
 */
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
