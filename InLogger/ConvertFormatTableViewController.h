//
//  ConvertFormatTableViewController.h
//  Genomizer
//
//  Created by Mattias Scherer on 04/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileContainer.h"
@interface ConvertFormatTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *files;
@property BOOL isPickerVisible;
@end
