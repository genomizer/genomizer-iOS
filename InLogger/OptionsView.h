//
//  OptionsView.h
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-17.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionsView;
@protocol OptionsActionDelegate <NSObject>
-(void)optionsViewDidClose:(OptionsView *)ov;
@end
@protocol OptionsViewDelegate <NSObject>
-(void)optionsView:(OptionsView *)ov selectedIndex:(NSUInteger)index;
@end
@interface OptionsView : UITableView<UITableViewDataSource, UITableViewDelegate>{
    id<OptionsViewDelegate>optionsDelegate;
    id<OptionsActionDelegate>actionDelegate;
}

@property (nonatomic, retain) id<OptionsViewDelegate>optionsDelegate;
@property (nonatomic, retain) id<OptionsActionDelegate>actionDelegate;
@property (nonatomic, retain) UIView *dimView;

-(void)setDataArray:(NSArray *)array;
@end
