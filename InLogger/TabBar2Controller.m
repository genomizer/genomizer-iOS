//
//  TabViewController.m
//  Genomizer
//
//  The TabViewController contains methods to automatically avoid
//  two segues to be executed at the same time.
//
//

#import "TabBar2Controller.h"
#import "AppDelegate.h"
#import "NavController.h"

@interface TabBar2Controller (){
    NSMutableArray *messagesToShow;
    NSArray *childControllers;
}

@property NSUInteger prevSelectedIndex;

@end

@implementation TabBar2Controller
@synthesize window, tabBar, panner;

/**
 * Initial setup on view did load. Add self to appdelegate.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    messagesToShow = [[NSMutableArray alloc] init];

    self.view.backgroundColor = [UIColor blackColor];
    _prevSelectedIndex = 0;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NavController *nvc1 = [story instantiateViewControllerWithIdentifier:@"search"];
    NavController *nvc2 = [story instantiateViewControllerWithIdentifier:@"selected"];
    NavController *nvc3 = [story instantiateViewControllerWithIdentifier:@"process"];
    NavController *nvc4 = [story instantiateViewControllerWithIdentifier:@"more"];
    
    
    nvc1.tabBar2Controller = self;
    nvc2.tabBar2Controller = self;
    nvc3.tabBar2Controller = self;
    nvc4.tabBar2Controller = self;
    
    childControllers = @[nvc1, nvc2, nvc3, nvc4];
    
    [self.view insertSubview:nvc1.view belowSubview:self.tabBar];
    self.selectedViewController = nvc1;
    
    panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:panner];
    panner.delegate = self;
    
    for(UIView *v in self.tabBar.subviews){
        if(v.tag != [childControllers indexOfObject:self.selectedViewController]+100){
            v.alpha = 0.3;
        }
    }
    
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    return !CGRectContainsPoint(self.tabBar.frame, location) && fabs(translation.x) > fabs(translation.y);
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if([otherGestureRecognizer.view isKindOfClass:[UITableView class]]){
        return false;
    }
    return true;
}

-(UIViewController *)getSelecterViewController{
    return _selectedViewController;
}

-(void)setSelectedViewController:(UIViewController *)selectedViewController{
    NSUInteger prevSelected = [childControllers indexOfObject:_selectedViewController];
    
    _selectedViewController = selectedViewController;
    NSUInteger currentIndex = [childControllers indexOfObject:self.selectedViewController];
    UIButton *prevButton = (UIButton *)[self.tabBar viewWithTag:100 + prevSelected];
    UIButton *selectedButton = (UIButton *)[self.tabBar viewWithTag:100 + currentIndex];
    prevButton.alpha = 0.3;
    selectedButton.alpha = 1.0;
    
}

//Pål svamlar
-(void)pan:(UIPanGestureRecognizer *)_panner{
    CGPoint translation = [_panner translationInView:_panner.view];
     NSUInteger currentIndex = [childControllers indexOfObject:self.selectedViewController];

    UIViewController *nav = self.selectedViewController;
    UIViewController *rightVC = currentIndex == childControllers.count-1 ? nil : childControllers[currentIndex+1];
    UIViewController *leftVC = currentIndex == 0 ? nil : childControllers[currentIndex-1];
    
    if(_panner.state == UIGestureRecognizerStateBegan){

        leftVC.view.center  = CGPointMake(nav.view.center.x - self.view.frame.size.width - 10, leftVC.view.center.y);
        rightVC.view.center = CGPointMake(nav.view.center.x + self.view.frame.size.width + 10, rightVC.view.center.y);
        [self.view insertSubview:rightVC.view belowSubview:self.tabBar];
        [self.view insertSubview:leftVC.view belowSubview:self.tabBar];

    } else if(_panner.state == UIGestureRecognizerStateEnded){
        
        CGPoint velocity = [_panner velocityInView:_panner.view];
        float dist = fabs(leftVC.view.center.x - self.view.frame.size.width/2);
        float duration = dist / velocity.x;
        
        if((velocity.x < -200) && currentIndex != childControllers.count-1){
            
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                
                leftVC.view.center  = CGPointMake(self.view.frame.size.width/2-(self.view.frame.size.width+10)*2, nav.view.center.y);
                nav.view.center     = CGPointMake(self.view.frame.size.width/2-(self.view.frame.size.width+10), nav.view.center.y);
                rightVC.view.center = CGPointMake(self.view.frame.size.width/2, rightVC.view.center.y);
                                 
            } completion:^(BOOL finished) {
                [nav.view removeFromSuperview];
                [leftVC.view removeFromSuperview];
                leftVC.view.center = rightVC.view.center;
                nav.view.center = rightVC.view.center;
                self.selectedViewController = rightVC;
            }];
            
        } else if((velocity.x > 200) && currentIndex != 0){

            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                nav.view.center     = CGPointMake(self.view.frame.size.width/2+(self.view.frame.size.width+10), nav.view.center.y);
                leftVC.view.center  = CGPointMake(self.view.frame.size.width/2, leftVC.view.center.y);
                rightVC.view.center = CGPointMake(self.view.frame.size.width/2+(self.view.frame.size.width+10)*2, nav.view.center.y);
                                 
            } completion:^(BOOL finished) {
                [nav.view removeFromSuperview];
                [rightVC.view removeFromSuperview];
                rightVC.view.center = leftVC.view.center;
                nav.view.center = leftVC.view.center;
                self.selectedViewController = leftVC;
            }];
            
        } else{
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                nav.view.center = CGPointMake(self.view.frame.size.width/2, nav.view.center.y);
                rightVC.view.center = CGPointMake(self.view.frame.size.width/2 + (self.view.frame.size.width+10), rightVC.view.center.y);
                leftVC.view.center  = CGPointMake(self.view.frame.size.width/2 - (self.view.frame.size.width+10), leftVC.view.center.y);
                
            } completion:^(BOOL finished) {
                [leftVC.view removeFromSuperview];
                [rightVC.view removeFromSuperview];
                leftVC.view.center = nav.view.center;
                rightVC.view.center = nav.view.center;
            }];
        }
    }
    
    float friction = currentIndex == 0 && nav.view.center.x                     >= self.view.frame.size.width/2 ? 0.2 : 1.0;
    friction = currentIndex == childControllers.count-1 && nav.view.center.x    <= self.view.frame.size.width/2 ? 0.2 : friction;
    nav.view.center = CGPointMake(nav.view.center.x + translation.x * friction, _panner.view.center.y);
    rightVC.view.center = CGPointMake(rightVC.view.center.x + translation.x * friction, rightVC.view.center.y);
    leftVC.view.center = CGPointMake(leftVC.view.center.x + translation.x * friction, leftVC.view.center.y);
    [_panner setTranslation:CGPointZero inView:_panner.view];
}

-(IBAction)tabbarButtonTapped:(UIButton *)sender{

    UIViewController *vc = [childControllers objectAtIndex:sender.tag-100];
    
    if(vc == self.selectedViewController){
        UINavigationController *nav = (UINavigationController *)self.selectedViewController;
        [nav popToRootViewControllerAnimated:true];
        return;
    }
    NSLog(@"new vc %@, oldvc: %@", vc, self.selectedViewController);
    
    [self.view insertSubview:vc.view belowSubview:self.tabBar];
    [self.selectedViewController.view removeFromSuperview];
    
    self.selectedViewController = vc;
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


-(void)showOptions:(NSArray *)options delegate:(id<OptionsViewDelegate>)delegate{
     UIView *dimView = [self getDimView];
    
    
    OptionsView *ov = [[OptionsView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - options.count*50-100, self.view.frame.size.width, options.count*50+100)];
    ov.transform = CGAffineTransformMakeTranslation(0, ov.frame.size.height);
    [ov setDataArray:options];
    ov.actionDelegate = self;
    ov.optionsDelegate = delegate;
    ov.dimView = dimView;
  
    [self zoomViewBackIntoDarkness];
    
    [self.view addSubview:dimView];
    [self.view addSubview:ov];
    
    [UIView animateWithDuration:0.2 animations:^{
        ov.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    [self animateDimViewIn:dimView];
}
-(void)optionsViewDidClose:(OptionsView *)ov{
    [self zoomViewRestore];
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
    
    NSString *title =   d[@"title"];
    NSString *msg =     d[@"message"];
    NSString *type =    d[@"type"];
    
    window = [[AlertWindow alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)
                                          title:title
                                        message:msg
                                           type:type];
    
    [window animateDownAndUp:^{
        if(messagesToShow.count > 0){
            [messagesToShow removeObjectAtIndex:0];
            [self showNextMessage];
        }
        
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
