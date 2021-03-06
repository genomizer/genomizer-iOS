//
//  DataFileViewController.m
//  Genomizer
//
//  Class that handles the Data File view for search results.
//

#import <UIKit/UIKit.h>
#import "Experiment.h"
#import "ViewController.h"

@interface DataFileViewController : ViewController

@property (nonatomic) Experiment *experiment;
@property FileContainer *selectedFiles;
@property (nonatomic, retain) IBOutlet UIButton *processButton;

- (IBAction) unwindToList:(UIStoryboardSegue *)segue;
-(IBAction)starButtonTapped:(UIButton *)sender;
-(IBAction)clearButtonTapped:(id)sender;
- (void) showInfoAbout: (ExperimentFile *) file;

@end
