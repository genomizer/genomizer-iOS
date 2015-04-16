//
//  RawConvertViewController.h
//  Genomizer
//
//  This class makes a convertrequest from data specified by the user and
//  converts the files that was selected by the user in the searchResult or
//  selectedfiles -view from raw to profile. Uses the method convert in
//  serverConnection to send the request to the server.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "ProcessViewController.h"

@interface RawConvertViewController : TableViewController<UITextFieldDelegate>
@property NSMutableArray * experimentFiles;
@property NSInteger * type;
@property BOOL ratio;
@property (nonatomic, copy) ProcessViewController *aReference;
@property (readwrite, copy) void (^completionBlock)(NSError *error, NSString *message);

- (void) reportResult: (NSError*) error experiment: (NSString*) expid;
- (void) reportGenomeResult:(NSMutableArray*) genomeReleases withError:(NSError*) error;
@end

