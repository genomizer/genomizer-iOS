//
//  SearchResultTableViewController.h
//  Genomizer
//
//  Class that handles the search result view
//

#import <UIKit/UIKit.h>
#import "Experiment.h"
#import "ExperimentDescriber.h"
#import "TableViewController.h"

@interface SearchResultTableViewController : TableViewController

@property ExperimentDescriber *experimentDescriber;
@property Experiment * selectedExperiment;
@property Experiment *selectedFiles;
@property NSArray *searchResults;


- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
