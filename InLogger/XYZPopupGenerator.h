//
//  XYZPopupGenerator.h
//  InLogger
//
//  Created by Marc Armgren on 08/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZPopupGenerator : NSObject

+ (void)showPopupWithMessage: (NSString *) message;
+ (void)showPopupWithMessage: (NSString *) message withTitle: (NSString *) title;
+ (void)showPopupWithMessage: (NSString *) message withTitle: (NSString *) title
       withCancelButtonTitle: (NSString *) cancelTitle;
+ (void) showInputPopupWithMessage: (NSString *) message withTitle: (NSString *) title withText: (NSString *) text withDelegate: (id) delegate;
+ (void) showErrorMessage: (NSError *) error;
+ (void) showActivityIndicatorOnView: (UIView *) view;

@end
