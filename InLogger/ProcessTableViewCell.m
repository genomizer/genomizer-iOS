//
//  ProcessTableViewCell.m
//  Genomizer
//
//  Created by Linus Öberg on 15/05/14.
//  Copyright (c) 2014 Linus Öberg. All rights reserved.
//

#import "ProcessTableViewCell.h"

@implementation ProcessTableViewCell

- (ProcessTableViewCell *) init
{
    self = [super init];
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
