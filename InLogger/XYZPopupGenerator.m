//
//  XYZPopupGenerator.m
//  InLogger
//
//  Created by Marc Armgren on 08/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import "XYZPopupGenerator.h"

@implementation XYZPopupGenerator

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

+ (void) showErrorMessage:(NSError *)error
{
    NSString * errorMsg = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    [XYZPopupGenerator showPopupWithMessage:errorMsg withTitle:error.domain];
}

@end
