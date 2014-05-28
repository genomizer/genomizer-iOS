//
//  XYZLogInViewController.h
//  InLogger
//
//  Created by Joel Viklund on 24/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>


@interface XYZLogInViewController : XYZViewController<UITextFieldDelegate>
- (void) reportLoginResult: (NSError*) error;
@end
