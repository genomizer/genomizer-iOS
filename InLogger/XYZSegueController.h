//
//  XYZSegueController.h
//  Genomizer
//
//  The XYZSeguwController controlls the segues to automatically avoid
//  two segues to be executed at the same time. It contains static methods
//  to keep track of if a segue is animating.
//

#import <Foundation/Foundation.h>

@interface XYZSegueController : NSObject

+ (BOOL) isPerformingSegue;
+ (void) segueDone;
+ (void) segueStarted;

@end
