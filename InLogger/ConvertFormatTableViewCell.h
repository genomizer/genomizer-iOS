//
//  ConvertFormatTableViewCell.h
//  Genomizer
//
//  Created by Mattias Scherer on 06/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConvertFormatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *format;

@end
