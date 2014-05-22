//
//  XYZSettingsPopupDelegate.m
//  Genomizer
//
//  Created by Joel Viklund on 22/05/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import "XYZSettingsPopupDelegate.h"
#import "JSONBuilder.h"
#import "XYZFileHandler.h"


@interface XYZSettingsPopupDelegate ()

@end

@implementation XYZSettingsPopupDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    [JSONBuilder setServerURLToString:textField.text];
    [XYZFileHandler writeData:textField.text toFile:SERVER_URL_FILE_NAME];
}

@end
