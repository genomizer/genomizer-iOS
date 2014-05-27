//
//  RawConvertViewController.h
//  InLogger
//
//  Created by Linus Öberg on 08/05/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZTableViewController.h"
#import "ProcessViewController.h"

@interface RawConvertViewController : XYZTableViewController<UITextFieldDelegate>
@property NSMutableArray * experimentFiles;
@property NSInteger * type;
@property BOOL ratio;
@property (nonatomic, copy) ProcessViewController *aReference;

- (void) reportResult: (NSError*) error experiment: (NSString*) expid;
- (void) reportGenomeResult:(NSMutableArray*) genomeReleases withError:(NSError*) error;
@end

