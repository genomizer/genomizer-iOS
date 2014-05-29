//
//  XYZSettingsPopupDelegate.m
//  Genomizer
//

#import "XYZSettingsPopupDelegate.h"
#import "JSONBuilder.h"
#import "XYZFileHandler.h"
#import "XYZPopupGenerator.h"


@interface XYZSettingsPopupDelegate ()

@end

@implementation XYZSettingsPopupDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSURLRequest *candidateURL = [NSURLRequest requestWithURL:[NSURL URLWithString: textField.text]];

    if ([NSURLConnection canHandleRequest:candidateURL])
    {
        [JSONBuilder setServerURLToString:textField.text];
        [XYZFileHandler writeData: [JSONBuilder getServerURL] toFile:SERVER_URL_FILE_NAME];
    }
    else
    {
        [XYZPopupGenerator showPopupWithMessage:(@"Invalid URL entered")];
    }
}

@end
