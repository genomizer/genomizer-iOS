//
//  SearchTableViewCell.h
//  Genomizer
//
// Class that represents a cell in the searchView tableView.
// Contains logic for which switchButton should be activated when
// and what should happen when textfields have begin/end-editing.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import "Annotation.h"

@interface SearchTableViewCell : UITableViewCell<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property SearchViewController *controller;
@property Annotation *annotation;

@end
