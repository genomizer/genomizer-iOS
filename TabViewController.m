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

/**
 Show a information popup about a file
 @param file shows information about file
 */
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

/**
 Shows a AlertWindow of type "error" and with text about error
 @param error error which should be notified to user
 */
-(void)showPopDownWithError:(NSError *)error{
    NSString * errorMsg = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    [self showPopDownWithTitle:error.domain andMessage:errorMsg type:@"error"];
}
/**
 Shows a AlertWindow with title, msg and type
 @param title Title of AlertWindow
 @param msg Message of AlertWindow, should be more descriptive
 @param type Type of AlertWindow
 */
-(void)showPopDownWithTitle:(NSString *)title andMessage:(NSString *)msg type:(NSString *)type{

    NSDictionary *dictMsg = @{@"title":title, @"message":msg, @"type":type};
    if(![messagesToShow containsObject:dictMsg]){
        [messagesToShow addObject:dictMsg];
        
        if(messagesToShow.firstObject == dictMsg){
            [self showNextMessage];
        }
    }
}

-(void)showNextMessage{
    if(messagesToShow.count == 0){

        window = nil;

        return;
    }
    
    NSDictionary *d = messagesToShow.firstObject;

    NSString *title = d[@"title"];
    NSString *msg = d[@"message"];
    NSString *type = d[@"type"];
    
    window = [[AlertWindow alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)
                                          title:title
                                        message:msg
                                          type:type];

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
