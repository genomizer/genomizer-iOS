//
//  PopupGenerator.h
//  Genomizer
//
//  The PopupGenerator contains static methods to generate and display
//  pop-ups of different sorts.
//
//

#import <Foundation/Foundation.h>

@interface PopupGenerator : NSObject

+ (void)showPopupWithMessage: (NSString *) message;
+ (void)showPopupWithMessage: (NSString *) message withTitle: (NSString *) title;
+ (void)showPopupWithMessage: (NSString *) message withTitle: (NSString *) title
       withCancelButtonTitle: (NSString *) cancelTitle;
+ (void)showPopupWithMessage: (NSString *) message withTitle: (NSString *) title
       withCancelButtonTitle: (NSString *) cancelTitle withDelegate: (id) delegate;
+ (void) showInputPopupWithMessage: (NSString *) message withTitle: (NSString *) title withText: (NSString *) text withDelegate: (id) delegate;
+ (void) showErrorMessage: (NSError *) error;
+ (void) showActivityIndicatorOnView: (UIView *) view;

@end
