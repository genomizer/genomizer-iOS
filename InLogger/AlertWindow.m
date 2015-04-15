//
//  AlertWindow.m
//  Genomizer
//
//  Created by Pål Forsberg on 2015-04-15.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

#import "AlertWindow.h"
#import "AppDelegate.h"

typedef enum {
    kDown,
    kUp
} State;

@implementation AlertWindow{
    UIView *view;
    BOOL animating;
    State currentState;
    void (^totalCompletion)();
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)msg color:(UIColor *)color{
    
    if(self = [super initWithFrame:frame]){
        animating = false;
        currentState = kUp;
        
        UILabel *titleLabel = ({
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, 20)];
            l.text = title;
            l.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.f];
            l.textAlignment = NSTextAlignmentCenter;
            l.textColor = [UIColor whiteColor];
            l;
        });
        
        UITextView *message = ({
            UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(40, 15, frame.size.width - 80, 44)];
            tv.text = msg;
            tv.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.f];
            tv.textAlignment = titleLabel.textAlignment;
            tv.textColor = titleLabel.textColor;
            tv.backgroundColor = [UIColor clearColor];
            tv.editable = false;
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
        
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView:)];
        [view addGestureRecognizer:tapper];
        
        [self addSubview:view];
    }
    
    return self;
}

-(void)tappedView:(UITapGestureRecognizer *)tapper{
    [self animateUp:0.2 completion:^{
        [self doneAnimating];
    }];
}

-(void)animateDown:(void(^)())completion{
    animating = true;
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        animating = false;
        currentState = kDown;
        completion();
    }];
}

-(void)animateUp:(float)duration completion:(void(^)())completion{
    animating = true;
    [UIView animateWithDuration:duration animations:^{
        view.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
    } completion:^(BOOL finished) {
        animating = false;
        currentState = kUp;
        completion();
        
    }];
}

-(void)animateDownAndUp:(void(^)())completion{
    totalCompletion = completion;
    [self animateDown:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if(!animating && currentState == kDown){
                [self animateUp:0.4 completion:^{
                    [self doneAnimating];
                }];
            }
        });
    }];
    
//    [self performSelector:@selector(animateUp) withObject:view afterDelay:2.0];

}

-(void)doneAnimating{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window makeKeyWindow];
    
    [view removeFromSuperview];
    [self removeFromSuperview];
    totalCompletion();
}
@end
