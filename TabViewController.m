//
//  TabViewController.m
//  Genomizer
//
//  The TabViewController contains methods to automatically avoid
//  two segues to be executed at the same time.
//
//

#import "SegueController.h"
#import "TabViewController.h"
#import "AppDelegate.h"


@interface TabViewController (){
    NSMutableArray *messagesToShow;
}

@property NSUInteger prevSelectedIndex;

@end

@implementation TabViewController
@synthesize window;

#define kErrorColor [UIColor colorWithRed:199/255.f green:53/255.f blue:53/255.f alpha:1.0]
/**
 * Initial setup on view did load. Add self to appdelegate.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    messagesToShow = [[NSMutableArray alloc] init];
    self.delegate = self;
    self.navigationItem.hidesBackButton = YES;
    _prevSelectedIndex = 0;
    
}

/**
 * Marks the segue as started.
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [SegueController segueStarted];
}

/**
 * Determines if a segue should be performed. Checks if a segue already is animating.
 *
 */
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([SegueController isPerformingSegue]) {
        return false;
    } else if(viewController != tabBarController.selectedViewController) {
        return true;
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)viewController).viewControllers.count > 1;
    } else {
        return true;
    }
}

-(void)showInfoAboutFile:(ExperimentFile *)file{
    NSString *infoText = [file getAllInfo];
    UIView *dimView = ({
        UIView *v = [[UIView alloc] initWithFrame:self.view.frame];
        v.backgroundColor = [UIColor blackColor];
        v.alpha = 0.4;
        v;
    });
    FileAboutView *fav = ({
        float height = 150;
        FileAboutView *fav = [[FileAboutView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2 - height/2, self.view.frame.size.width, height)];
        fav.delegate = self;
        [fav setText:infoText];
        fav.dimView = dimView;
        fav;
    });
    
    [self.view addSubview:dimView];
    [self.view addSubview:fav];
}

-(void)showPopUpWithError:(NSError *)error{
    NSString * errorMsg = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    [self showPopUpWithTitle:error.domain andMessage:errorMsg type:@"error"];
}
-(void)showPopUpWithTitle:(NSString *)title andMessage:(NSString *)msg type:(NSString *)type{
    UIColor *color;
    if([type isEqualToString:@"error"]){
        color = kErrorColor;
    }
    NSDictionary *dictMsg = @{@"title":title, @"message":msg, @"color":color};
    if(![messagesToShow containsObject:dictMsg]){
        [messagesToShow addObject:dictMsg];
        
        if(messagesToShow.firstObject == dictMsg){
            [self showNextMessage];
        }
    }
}

-(void)showNextMessage{
    if(messagesToShow.count == 0){
        return;
    }
    
    NSDictionary *d = messagesToShow.firstObject;
    
    
    NSString *title = d[@"title"];
    NSString *msg = d[@"message"];
    UIColor *color = d[@"color"];

    window = [[AlertWindow alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)
                                          title:title
                                        message:msg
                                          color:color];

    [window animateDownAndUp:^{
        [messagesToShow removeObjectAtIndex:0];
        [self showNextMessage];
    }];

}

-(void)hidePopUp:(UIView *)v{
    
}

-(void)fileAboutViewDidClose:(FileAboutView *)fav{
    
}

@end
