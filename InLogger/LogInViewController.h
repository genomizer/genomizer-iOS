//
//  LogInViewController.h
//  Genomizer
//

//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>

/**
 //  Class that handles the loginScreen
 */
@interface LogInViewController : ViewController<UITextFieldDelegate>
- (void) reportLoginResult: (NSError*) error;
@end
