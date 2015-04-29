 //
//  SettingsPopupDelegate.m
//  Genomizer
//

#import "SettingsPopupDelegate.h"
#import "JSONBuilder.h"
#import "FileHandler.h"
#import "PopupGenerator.h"
#import "Reachability.h"
#include <arpa/inet.h>

@interface SettingsPopupDelegate ()

@end

@implementation SettingsPopupDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (buttonIndex == 0) {
        [JSONBuilder setServerURLFromString:textField.text];
        [FileHandler writeData: [JSONBuilder getServerURL] toFile:SERVER_URL_FILE_NAME];
    }
}

@end
