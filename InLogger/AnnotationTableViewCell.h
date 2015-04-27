//
//  AnnotationTableViewCell.h
//  Genomizer
//

//


#import <UIKit/UIKit.h>

/**
 *  Class that describes a cell in the AnnotationTable.
 */
@interface AnnotationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end
