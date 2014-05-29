//
//  XYZAnnotationTableViewController.h
//  Genomizer
//
//  Class that handles the view for showing/hiding annotations in the search result cells.
//  This class uses XYZExperimentDescriber to handle data storage.
//

#import <UIKit/UIKit.h>
#import "XYZTableViewController.h"
#import "XYZExperimentDescriber.h"

@interface XYZAnnotationTableViewController : XYZTableViewController

@property XYZExperimentDescriber *describer;

@end
