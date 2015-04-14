//
//  SettingsPopupDelegate.m
//  Genomizer
//

#import "SettingsPopupDelegate.h"
#import "JSONBuilder.h"
#import "FileHandler.h"
#import "PopupGenerator.h"


@interface SettingsPopupDelegate ()

@end

@implementation SettingsPopupDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSURLRequest *candidateURL = [NSURLRequest requestWithURL:[NSURL URLWithString: textField.text]];

    if ([NSURLConnection canHandleRequest:candidateURL])
    {
        [JSONBuilder setServerURLToString:textField.text];
        [FileHandler writeData: [JSONBuilder getServerURL] toFile:SERVER_URL_FILE_NAME];
    }
    else
    {
        [PopupGenerator showPopupWithMessage:(@"Invalid URL entered")];
    }
}

@end
