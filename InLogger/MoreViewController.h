//
//  MoreViewController.h
//  Genomizer
//
// Class that represents a cell in the searchView tableView.
// Contains logic for which switchButton should be activated when
// and what should happen when textfields have begin/end-editing.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

/**
 Controlls the More view of the application. 
 */
@interface MoreViewController : ViewController

@property (nonatomic, retain) IBOutlet UILabel *userLabel;
@property (nonatomic, retain) IBOutlet UILabel *serverLabel;

- (IBAction)logoutButtonTouched:(id)sender;

@end
