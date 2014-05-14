//
//  RawConvertViewController.h
//  InLogger
//
//  Created by Linus Öberg on 08/05/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RawConvertViewController : UIViewController<UITextFieldDelegate>
@property NSMutableArray * experimentFiles;

- (void) reportResult: (NSError*) error;

@end

