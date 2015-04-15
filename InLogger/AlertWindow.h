//
//  AlertWindow.h
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-15.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertWindow : UIWindow


-(id)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)msg color:(UIColor *)color image:(NSString *)imageName;

-(void)animateDownAndUp:(void(^)())completion;
@end
