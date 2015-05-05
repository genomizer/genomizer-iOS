//
//  SearchViewController.h
//  Genomizer
//
// Class that controlls the SearchView. the searchView shows a list of annotations
// the user is avaliable to search for to retrive an experiment. The annotations is
// recived from the server. when the a search button is pressed a request to find
// experiments matching the searchvalues are sent to the server.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
//#import "ExperimentDescriber.h"
//#import "AdvancedSearchView.h"

@interface SearchViewController : ViewController<UITextFieldDelegate, AdvancedSearchViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property UIPickerView *pickerView;
@property UIToolbar *toolBar;
@property NSArray *annotations;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIView *searchButtonView;

- (void) hideKeyboardAndAdjustTable;
- (void) scrollToCell: (UITableViewCell *) cell;
- (void) reportSearchResult: (NSMutableArray*) result error: (NSError*) error;
- (void) reportAnnotationResult: (NSArray*) result error: (NSError*) error;
- (void) switchDidChange;

@end
