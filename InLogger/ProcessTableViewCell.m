//
//  ProcessTableViewCell.m
//  Genomizer
//
//  Class that represents one cell in the tableview.
//

#import "ProcessTableViewCell.h"

@implementation ProcessTableViewCell

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
