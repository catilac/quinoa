//
//  QuinoaTabBarViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/19/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "QuinoaTabBarViewController.h"
#import "TrackButton.h"
#import "FanOutViewController.h"
#import "ExpertDetailViewController.h"
#import "ChatViewController.h"

@interface QuinoaTabBarViewController ()

@property (strong, nonatomic) TrackButton *trackButton;

@end

@implementation QuinoaTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate = self;
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)popBackToLastTabBarView {
    [self setSelectedIndex:self.lastIndex];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popBackToLastTabBarView)
                                                 name:kCloseMenu
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNavigation:)
                                                 name:@"hasExpert"
                                               object:nil];

    // Add custom view for custom track UITabBarItem
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.trackButton = [[TrackButton alloc] initWithFrame:CGRectMake(screenSize.width/2-35, screenSize.height-55, 70, 110)];
    self.trackButton.layer.cornerRadius = 3;
    [self.view addSubview:self.trackButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateNavigation:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"hasExpert"]) {
        // Refresh tabbar navigation with Expert Detail
        //ExpertDetailViewController *expertViewController = [[ExpertDetailViewController alloc] initWithExpert:[User currentUser].currentTrainer];
        ChatViewController *expertViewController = [[ChatViewController alloc] initWithUser:[User currentUser].currentTrainer];
        UINavigationController *expertNavController = [[UINavigationController alloc] initWithRootViewController:expertViewController];
        expertNavController.tabBarItem.image = [[UIImage imageNamed:@"myClients"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        expertNavController.tabBarItem.selectedImage = [[UIImage imageNamed:@"myClients-selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        NSMutableArray *newControllers = [[NSMutableArray alloc] init];
        [newControllers addObjectsFromArray:self.viewControllers];
        [newControllers replaceObjectAtIndex:1 withObject:expertNavController];
        self.viewControllers = [newControllers copy];
    }
}

#pragma mark - UITabBarControllerDelegate methods
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex != 2) {
        self.lastIndex = tabBarController.selectedIndex;
        [[NSNotificationCenter defaultCenter] postNotificationName:kCloseMenu object:nil];
    }
}

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
           animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                             toViewController:(UIViewController *)toVC {
    return self;
}

#pragma mark UIViewControllerAnimatedTransitioning methods
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    
    if (fromViewController.view.tag == kFanOutIdent) {
        toViewController.view.alpha = 0;
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             toViewController.view.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    } else {
        [transitionContext completeTransition:YES];
    }
    
}

@end
