//
//  LogInViewController.h
//  Genomizer
//
//  Class that handles the loginScreen
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>


@interface LogInViewController : ViewController<UITextFieldDelegate>
- (void) reportLoginResult: (NSError*) error;
@end
