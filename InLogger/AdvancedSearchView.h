//
//  AdvancedSearchView.h
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-17.
//  Copyright (c) 2015 Mattias. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdvancedSearchView;
@protocol AdvancedSearchViewDelegate <NSObject>
-(void)advancedSearchViewDidClose:(AdvancedSearchView *)adv;
-(void)advancedSearchViewDidSearch:(AdvancedSearchView *)adv;

@end
@interface AdvancedSearchView : UIView <UITextViewDelegate>{
    id<AdvancedSearchViewDelegate>delegate;
}

@property (nonatomic, retain) id<AdvancedSearchViewDelegate>delegate;
@property (nonatomic, retain) UIView *dimView;
-(void)setSearchText:(NSString *)text;
-(NSString *)getSearchText;
@end
