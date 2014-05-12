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

+ (void)showPopupWithMessage: (NSString *) message{
    UIAlertView *popup = [[UIAlertView alloc]
                          initWithTitle:@"" message: [XYZPopupGenerator formatMessage:message]
                          delegate:nil cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [popup show];
}

@end
