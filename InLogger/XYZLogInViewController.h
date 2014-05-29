//
//  XYZLogInViewController.h
//  Genomizer
//
//  Class that handles the loginScreen
//

#import <UIKit/UIKit.h>
#import "XYZViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>


@interface XYZLogInViewController : XYZViewController<UITextFieldDelegate>
- (void) reportLoginResult: (NSError*) error;
@end
