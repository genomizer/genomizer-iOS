//
//  AnnotationTableViewController.h
//  Genomizer
//
//  Class that handles the view for showing/hiding annotations in the search result cells.
//  This class uses ExperimentDescriber to handle data storage.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "ExperimentDescriber.h"

@interface AnnotationTableViewController : TableViewController

@property ExperimentDescriber *describer;

@end
