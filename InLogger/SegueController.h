//
//  SegueController.h
//  Genomizer
//
//  The SeguwController controlls the segues to automatically avoid
//  two segues to be executed at the same time. It contains static methods
//  to keep track of if a segue is animating.
//

#import <Foundation/Foundation.h>

@interface SegueController : NSObject

+ (BOOL) isPerformingSegue;
+ (void) segueDone;
+ (void) segueStarted;

@end
