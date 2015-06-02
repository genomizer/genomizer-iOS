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
-(void)processCell2:(Process2Cell *)cell didChangeValue:(id)val forKey:(NSString *)key forceReload:(BOOL)force;
-(void)processCell2:(Process2Cell *)cell didChangeOutFileName:(NSString *)outfileName;
-(void)processCell2:(Process2Cell *)cell didBeginEdit:(UITextField *)textField;
-(void)processCell2:(Process2Cell *)cell didEndEdit:(UITextField *)textField;
@end
@interface Process2Cell : UITableViewCell<UITextFieldDelegate>{
    id<Process2CellDelegate>delegate;
}

@property (nonatomic, retain) id<Process2CellDelegate>delegate;
@property (nonatomic, retain) IBOutlet UITextField *fileTextField;
@property (nonatomic, retain) IBOutlet UITextField *paramTextField;
@property (nonatomic, retain) IBOutlet UITextField *stepSizeTextField;
@property (nonatomic, retain) IBOutlet UITextField *windowSizeTextField;
@property (nonatomic, retain) IBOutlet UITextField *minSmoothTextField;
@property (nonatomic, retain) IBOutlet UITextField *meanOrMedianTextField;
@property (nonatomic, retain) IBOutlet UITextField *readsCutOffTextField;
@property (nonatomic, retain) IBOutlet UITextField *chromosomeTextField;
@property (nonatomic, retain) IBOutlet UITextField *filePostTextField;
@property (nonatomic, retain) IBOutlet UIButton *switchButton;
@property (nonatomic, retain) NSString *outfile_ext;


-(IBAction)ratioSwitchPrePost:(id)sender;


@end
