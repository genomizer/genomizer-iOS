//
//  AlertWindow.h
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-15.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Displays a AlertWindow above NavBar with specified text and type.
 
 */
@interface AlertWindow : UIWindow


-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)msg type:(NSString *)type;

-(void)animateDownAndUp:(void(^)())completion;
+(UIColor *)colorForType:(NSString *)type;
@end
