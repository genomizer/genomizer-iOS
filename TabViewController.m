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

@interface TabViewController ()

@property NSUInteger prevSelectedIndex;

@end

@implementation TabViewController

/**
 * Initial setup on view did load. Add self to appdelegate.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    NSString *infoText = @"Hejsan allihopa";//[file getAllInfo];
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

-(void)fileAboutViewDidClose:(FileAboutView *)fav{
    
}

@end
