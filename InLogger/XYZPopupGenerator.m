//
//  XYZPopupGenerator.m
//  InLogger
//
//  Created by Marc Armgren on 08/05/14.
//  Copyright (c) 2014 Marc Armgren. All rights reserved.
//

#import "XYZPopupGenerator.h"

@implementation XYZPopupGenerator

+ (void)showPopupWithMessage: (NSString *) message{
    UIAlertView *popup = [[UIAlertView alloc]
                          initWithTitle:@"" message:message
                          delegate:nil cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [popup show];
}

@end
