//
//  XYZSearchResultTableViewCell.h
//  InLogger
//
//  Created by Joel Viklund on 28/04/14.
//  Copyright (c) 2014 Joel Viklund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZSearchResultTableViewCell : UITableViewCell

@property XYZExperiment *experiment;

- (void) setTextFieldText: (NSString *) text;

@end
