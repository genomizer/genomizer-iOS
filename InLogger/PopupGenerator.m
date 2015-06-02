//
//  PopupGenerator.m
//  Genomizer
//
//  The PopupGenerator contains static methods to generate and display
//  pop-ups of different sorts.
//
//

#import "PopupGenerator.h"

@implementation PopupGenerator

static UIView * ACTIVITY_CONTAINER;
/**
 * Appends a dot to the given message if it doesn't contain a punctation
 * mark.
 *
 * @param message - the message to operate on
 *
 * @return the formated message
 *
 */
+ (NSString *) formatMessage: (NSString *) message
{
    NSMutableString *formatedMessage = [[NSMutableString alloc] init];
    [formatedMessage appendString:message];
    NSUInteger lastChar = [message characterAtIndex:[message length] - 1];
    if (lastChar != '.' && lastChar != '!' && lastChar != '?') {
        [formatedMessage appendString:@"."];
    }

    return formatedMessage;
    
}

+ (void)showPopupWithMessage: (NSString *) message {
    [PopupGenerator showPopupWithMessage:message withTitle:@""];
}

+ (void)showPopupWithMessage: (NSString *) message withTitle: (NSString *) title
{
    [PopupGenerator showPopupWithMessage:message withTitle:title withCancelButtonTitle:@"OK"];
}

+ (void)showPopupWithMessage: (NSString *) message withTitle: (NSString *) title
             withCancelButtonTitle: (NSString *) cancelTitle
{
    [PopupGenerator showPopupWithMessage: message withTitle:title withCancelButtonTitle:cancelTitle withDelegate:nil];
}

/**
 * Displays a pop-up with the given message, title, cancel-title and delegate.
 *
 * @param message - the message
 * @param title - the title
 * @param cancelTitle - the cancel title
 * @param delegate - the pop-up delegate
 *
 */
+ (void)showPopupWithMessage: (NSString *) message withTitle: (NSString *) title
       withCancelButtonTitle: (NSString *) cancelTitle withDelegate: (id) delegate
{
    UIAlertView *popup = [[UIAlertView alloc]
                          initWithTitle:title message: [PopupGenerator formatMessage:message]
                          delegate:delegate cancelButtonTitle:cancelTitle
                          otherButtonTitles:nil];
    [popup show];
    

}

/**
 * Displays an input pop-up with the given message, title, default text and delegate.
 *
 * @param message - the message
 * @param title - the title
 * @param text - the default input text
 * @param delegate - the pop-up delegate
 */
+ (void) showInputPopupWithMessage: (NSString *) message withTitle: (NSString *) title withText: (NSString *) text withDelegate: (id) delegate
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle: nil otherButtonTitles:@"Done", @"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    [textField setReturnKeyType:UIReturnKeyDone];
    textField.text = text;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [alert show];
}

/**
 * Displays a pop-up with information about the given error.
 *
 * @param error - the error
 */
+ (void) showErrorMessage:(NSError *)error
{
    NSString * errorMsg = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    [PopupGenerator showPopupWithMessage:errorMsg withTitle:error.domain];
}

/**
 * Displays an activity indicator on the given view.
 *
 * @param view - the view
 *
 */
+ (void) showActivityIndicatorOnView: (UIView *) view
{
    UIView *ACTIVITY_CONTAINER = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    ACTIVITY_CONTAINER.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.40];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((view.frame.size.width/2) - 40, (view.frame.size.height/2) - 40, 80, 80)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.backgroundColor = [UIColor blackColor];
    [indicator layer].cornerRadius = 8.0;
    [indicator layer].masksToBounds = YES;
    [ACTIVITY_CONTAINER addSubview:indicator];
    [indicator startAnimating];
    [view addSubview: ACTIVITY_CONTAINER];
    
}

/**
 * Hides the activity indicator.
 *
 */
+ (void) hideActivityIndicator
{
    [ACTIVITY_CONTAINER removeFromSuperview];
}

@end
