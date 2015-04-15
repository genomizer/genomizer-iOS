//
//  AlertWindow.m
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-15.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

#import "AlertWindow.h"
#import "AppDelegate.h"

@implementation AlertWindow{
    UIView *view;
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)msg color:(UIColor *)color{
    if(self = [super initWithFrame:frame]){
        UILabel *titleLabel = ({
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 20)];
            l.text = title;
            l.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.f];
            l.textAlignment = NSTextAlignmentCenter;
            l.textColor = [UIColor whiteColor];
            l;
        });
        
        UITextView *message = ({
            UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(40, 15, 320 - 80, 44)];
            tv.text = msg;
            tv.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.f];
            tv.textAlignment = titleLabel.textAlignment;
            tv.textColor = titleLabel.textColor;
            tv.backgroundColor = [UIColor clearColor];
            tv;
        });
        

        self.windowLevel = UIWindowLevelStatusBar+1;
        
        self.hidden = false;
        [self makeKeyAndVisible];
        
        view = [[UIView alloc] initWithFrame:self.bounds];
        view.transform = CGAffineTransformMakeTranslation(0, -view.frame.size.height);
        [view addSubview:titleLabel];
        view.backgroundColor = color;
        [view addSubview:message];
        
        [self addSubview:view];
    }
    return self;
}

-(void)animateDown:(void(^)())completion{
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        completion();
    }];
}

-(void)animateUp:(void(^)())completion{
    [UIView animateWithDuration:0.4 animations:^{
        view.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
    } completion:^(BOOL finished) {

        completion();
    }];
}

-(void)animateDownAndUp:(void(^)())completion{
    
    [self animateDown:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self animateUp:^{
                AppDelegate *app = [UIApplication sharedApplication].delegate;
                [app.window makeKeyWindow];
                
                [view removeFromSuperview];
                [self removeFromSuperview];
                completion();
            }];
        });
    }];
    
//    [self performSelector:@selector(animateUp) withObject:view afterDelay:2.0];

}
@end
