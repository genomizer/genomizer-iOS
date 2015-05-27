//
//  Process2Cell.h
//  Genomizer
//
//  Created by Erik Berggren on 25/05/15.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Process2Cell;
@protocol Process2CellDelegate <NSObject>
-(void)processCell2:(Process2Cell *)cell didChangeValue:(id)val forKey:(NSString *)key;
-(void)processCell2:(Process2Cell *)cell didChangeOutFileName:(NSString *)outfileName;
-(void)processCell2DidBeginEdit:(UITextField *)textField;

@end
@interface Process2Cell : UITableViewCell<UITextFieldDelegate>{
    id<Process2CellDelegate>delegate;
}

@property (nonatomic, retain) id<Process2CellDelegate>delegate;
//@property (nonatomic, retain) IBOutlet UILabel *inFileLabel;
//@property (nonatomic, retain) IBOutlet UILabel *outFileLabel;
@property (nonatomic, retain) IBOutlet UITextField *outFileTextField;
@property (nonatomic, retain) IBOutlet UITextField *paramTextField;
@property (nonatomic, retain) IBOutlet UITextField *stepSizeTextField;
@property (nonatomic, retain) IBOutlet UITextField *windowSizeTextField;
@property (nonatomic, retain) IBOutlet UITextField *minSmoothTextField;
@property (nonatomic, retain) IBOutlet UITextField *meanOrMedianTextField;
@property (nonatomic, retain) IBOutlet UITextField *readsCutOffTextField;
@property (nonatomic, retain) IBOutlet UITextField *chromosomeTextField;
@property (nonatomic, retain) IBOutlet UITextField *outFilePostTextField;
@property (nonatomic, retain) NSString *outfile_ext;


@end
