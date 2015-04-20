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
    UIView *rightView;
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
    self.view.backgroundColor = [UIColor whiteColor];
    _prevSelectedIndex = 0;
    
//    UIPanGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    [self.view addGestureRecognizer:panner];
}

//Pål svamlar
//-(void)pan:(UIPanGestureRecognizer *)panner{
//    CGPoint translation = [panner translationInView:panner.view];
//     NSUInteger currentIndex = [self.childViewControllers indexOfObject:self.selectedViewController];
//    
//    UINavigationController *nav = (UINavigationController *)self.selectedViewController;
//    UIViewController *rightVC = self.childViewControllers[currentIndex+1];
//    
//    if(panner.state == UIGestureRecognizerStateBegan){
//       
//        UIViewController *rightVC = self.childViewControllers[currentIndex+1];
//        
//        
//        if(!rightVC.isViewLoaded){
//            rightVC = [self.storyboard instantiateViewControllerWithIdentifier:rightVC.restorationIdentifier];
//        }
//        self
//        rightVC.view.center = CGPointMake(nav.view.center.x + 320, rightVC.view.center.y);
//        [self.view insertSubview:rightVC.view belowSubview:self.tabBar];
//        rightView = rightVC.view;
//        
//    } else if(panner.state == UIGestureRecognizerStateEnded){
//        [UIView animateWithDuration:0.3 animations:^{
//            nav.view.center = CGPointMake(self.view.frame.size.width/2, nav.view.center.y);
//            rightView.center = CGPointMake(self.view.frame.size.width/2 + 320, rightView.center.y);
//        } completion:^(BOOL finished) {
//            [rightView removeFromSuperview];
//            rightView = nil;
//        }];
//    }
//    nav.view.center = CGPointMake(nav.view.center.x + translation.x, panner.view.center.y);
//    rightVC.view.center = CGPointMake(rightView.center.x + translation.x, rightView.center.y);
//    [panner setTranslation:CGPointZero inView:panner.view];
//}
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


/*
 ██████╗  ██████╗ ██████╗ ██╗   ██╗██████╗ ███████╗
 ██╔══██╗██╔═══██╗██╔══██╗██║   ██║██╔══██╗██╔════╝
 ██████╔╝██║   ██║██████╔╝██║   ██║██████╔╝███████╗
 ██╔═══╝ ██║   ██║██╔═══╝ ██║   ██║██╔═══╝ ╚════██║
 ██║     ╚██████╔╝██║     ╚██████╔╝██║     ███████║
 ╚═╝      ╚═════╝ ╚═╝      ╚═════╝ ╚═╝     ╚══════╝
*/

-(void)zoomViewBackIntoDarkness{
    NSLog(@"DARKNESS");
    UIView *v = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:false];
    v.tag = 998;
    UIView *black = [[UIView alloc] initWithFrame:self.view.bounds];
    black.backgroundColor = [UIColor blackColor];
    black.tag = 999;
    
    [self.view addSubview:black];
    [self.view addSubview:v];
    
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationNone];
    [UIView animateWithDuration:0.2 animations:^{
        v.transform = CGAffineTransformMakeScale(0.93, 0.93);
    }];
}

-(void)zoomViewRestore{
    UIView *v = [self.view viewWithTag:998];
    UIView *black = [self.view viewWithTag:999];
    
    [UIView animateWithDuration:0.2 animations:^{
        v.transform =  CGAffineTransformMakeScale(1.0, 1.0);
    }completion:^(BOOL finished) {
        [v removeFromSuperview];
        [black removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
    }];
}

-(void)zoomViewIn:(UIView *)v{
    v.transform = CGAffineTransformMakeScale(0.9, 0.9);
    v.alpha = 0.4;
    [UIView animateWithDuration:0.2 animations:^{
        v.transform = CGAffineTransformMakeScale(1.0, 1.0);
        v.alpha = 1.0;
    }];
}


-(UIView *)getDimView{
    UIView *dimView = ({
        UIView *v = [[UIView alloc] initWithFrame:self.view.frame];
        v.backgroundColor = [UIColor blackColor];
        v.alpha = 0.8;
        v;
    });
    return dimView;
}
-(void)animateDimViewIn:(UIView *)dimView{
    float dimAlpha = dimView.alpha;
    dimView.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        dimView.alpha = dimAlpha;
    }];
}
/**
 Show a information popup about a file
 @param file shows information about file
 */
-(void)showInfoAboutFile:(ExperimentFile *)file{
    
    NSString *infoText = [file getAllInfo];
    UIView *dimView = [self getDimView];
    FileAboutView *fav = ({
        float height = 300;
        FileAboutView *fav = [[FileAboutView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2 - height/2, self.view.frame.size.width, height)];
        fav.delegate = self;
        [fav setText:infoText];
        fav.dimView = dimView;
        fav;
    });

    
    [self zoomViewBackIntoDarkness];
    
    [self.view addSubview:dimView];
    [self.view addSubview:fav];
    
    [self animateDimViewIn:dimView];
    [self zoomViewIn:fav];
}

-(void)showAdvancedSearchView:(NSString *)searchText delegate:(id<AdvancedSearchViewDelegate>)del{
    float height = 300;
    UIView *dimView = [self getDimView];
    
    AdvancedSearchView *adv = [[AdvancedSearchView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2 - height/2, self.view.frame.size.width, height)];
    adv.dimView = dimView;
    adv.delegate = del;
    [adv setSearchText:searchText];
    
    [self zoomViewBackIntoDarkness];
    
    [self.view addSubview:dimView];
    [self.view addSubview:adv];
    [self animateDimViewIn:dimView];
    [self zoomViewIn:adv];
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)fileAboutViewDidClose:(FileAboutView *)fav{
    [self zoomViewRestore];
}

@end
