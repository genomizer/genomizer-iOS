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

- (IBAction) unwindToList:(UIStoryboardSegue *)segue;
-(IBAction)starButtonTapped:(UIButton *)sender;
- (void) showInfoAbout: (ExperimentFile *) file;

@end
