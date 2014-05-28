//
//  XYZPopupGenerator.m
//  InLogger
//
//  Created by Marc Armgren on 08/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import "XYZPopupGenerator.h"

@implementation XYZPopupGenerator

static UIView * ACTIVITY_CONTAINER;

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
    [XYZPopupGenerator showPopupWithMessage:message withTitle:@""];
}

+ (void)showPopupWithMessage: (NSString *) message withTitle: (NSString *) title
{
    [XYZPopupGenerator showPopupWithMessage:message withTitle:title withCancelButtonTitle:@"OK"];
}

+ (void)showPopupWithMessage: (NSString *) message withTitle: (NSString *) title
             withCancelButtonTitle: (NSString *) cancelTitle
{
    UIAlertView *popup = [[UIAlertView alloc]
                          initWithTitle:title message: [XYZPopupGenerator formatMessage:message]
                          delegate:nil cancelButtonTitle:cancelTitle
                          otherButtonTitles:nil];
    [popup show];
}

+ (void) showInputPopupWithMessage: (NSString *) message withTitle: (NSString *) title withText: (NSString *) text withDelegate: (id) delegate
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.text = text;
    [alert show];
}

+ (void) showErrorMessage:(NSError *)error
{
    NSString * errorMsg = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    [XYZPopupGenerator showPopupWithMessage:errorMsg withTitle:error.domain];
}

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

+ (void) hideActivityIndicator
{
    [ACTIVITY_CONTAINER removeFromSuperview];
}

@end
