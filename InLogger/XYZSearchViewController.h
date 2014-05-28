//
//  XYZSearchViewController.h
//  Genomizer
//
// Class that controlls the SearchView. the searchView shows a list of annotations
// the user is avaliable to search for to retrive an experiment. The annotations is
// recived from the server. when the a search button is pressed a request to find
// experiments matching the searchvalues are sent to the server.
//

#import <UIKit/UIKit.h>
#import "XYZViewController.h"
#import "XYZExperimentDescriber.h"

@interface XYZSearchViewController : XYZViewController<UITextFieldDelegate>

@property UIPickerView *pickerView;
@property UIToolbar *toolBar;
@property NSArray *annotations;

- (void) hideKeyboardAndAdjustTable;
- (void) scrollToCell: (UITableViewCell *) cell;
- (void) reportSearchResult: (NSMutableArray*) result error: (NSError*) error;
- (void) reportAnnotationResult: (NSArray*) result error: (NSError*) error;

@end
