//
//  XYZSearchResultTableViewController.h
//  Genomizer
//
//  Class that handles the search result view
//

#import <UIKit/UIKit.h>
#import "XYZExperiment.h"
#import "XYZExperimentDescriber.h"
#import "XYZTableViewController.h"

@interface XYZSearchResultTableViewController : XYZTableViewController

@property XYZExperimentDescriber *experimentDescriber;
@property XYZExperiment * selectedExperiment;
@property XYZExperiment *selectedFiles;
@property NSArray *searchResults;

-(void) didSelectRow: (NSInteger) row;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
