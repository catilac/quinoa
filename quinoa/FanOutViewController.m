//
//  FanOutViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "FanOutViewController.h"
#import "TrackEatingViewController.h"
#import "ActivityViewController.h"
#import "TrackButton.h"
#import "UILabel+QuinoaLabel.h"
#import "UIImage+ImageEffects.h"
#import "Utils.h"

@interface FanOutViewController ()


@property (weak, nonatomic) IBOutlet UIButton *trackWeightButton;
@property (weak, nonatomic) IBOutlet UIButton *trackActivityButton;
@property (weak, nonatomic) IBOutlet UIButton *trackFoodButton;
@property (strong, nonatomic) UIImage *currentBackgroundImage;

- (IBAction)onTrackFood:(id)sender;
- (IBAction)onTrackWeight:(id)sender;
- (IBAction)onTrackActivity:(id)sender;
- (IBAction)onTapParentView:(id)sender;


@end

@implementation FanOutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(animateFanOutView)
                                                 name:kCloseMenu
                                               object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    // hidden 130, viewheight - 60, 60, 60
    [UIView animateWithDuration:.6 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:16 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.trackWeightButton.frame = CGRectMake(45, self.view.frame.size.height - 100, 60, 60);
        self.trackActivityButton.frame = CGRectMake(130, self.view.frame.size.height - 100, 60, 60);
        self.trackFoodButton.frame = CGRectMake(215, self.view.frame.size.height - 100, 60, 60);
        NSLog(@"View Appeared");
        
    } completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOpenMenu object:nil];
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self blurBackground];
}

- (void)animateFanOutView {
    [UIView animateWithDuration:.6 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:16 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.trackWeightButton.frame = CGRectMake(45, self.view.frame.size.height, 60, 60);
        self.trackActivityButton.frame = CGRectMake(130, self.view.frame.size.height, 60, 60);
        self.trackFoodButton.frame = CGRectMake(215, self.view.frame.size.height, 60, 60);
    } completion:^(BOOL finished){
        [self undoBlurBackground];
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onTrackFood:(id)sender {
    TrackEatingViewController *trackEatingVC = [[TrackEatingViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:trackEatingVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)onTrackWeight:(id)sender {
    
    ActivityViewController *trackViewController = [[ActivityViewController alloc] initWithType:@"trackWeight"];

    UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:self.currentBackgroundImage];
    [trackViewController.view addSubview:backgroundImageView];
    [trackViewController.view sendSubviewToBack:backgroundImageView];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:trackViewController];
    //[self presentViewController:nav animated:NO completion:nil];
    
    UIView *overlay = [[UIView alloc] initWithFrame:self.view.frame];
    overlay.backgroundColor = [UIColor blackColor];
    overlay.alpha = 0;
    [self.view addSubview:overlay];
    [self.view bringSubviewToFront:overlay];
    
    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        overlay.alpha = 0.65;
        
        self.trackActivityButton.transform = CGAffineTransformMakeScale(.1, .1);
        self.trackFoodButton.transform = CGAffineTransformMakeScale(.1, .1);
        
        self.trackActivityButton.transform = CGAffineTransformMakeTranslation(0, 25);
        self.trackFoodButton.transform = CGAffineTransformMakeTranslation(0, 25);
        self.trackWeightButton.transform = CGAffineTransformMakeTranslation(0, -50);
        
        self.trackWeightButton.alpha = 0;
        self.trackFoodButton.alpha = 0;
        self.trackActivityButton.alpha = 0;
        
    } completion:^(BOOL finished) {
        self.trackActivityButton.transform = CGAffineTransformMakeScale(10, 10);
        self.trackFoodButton.transform = CGAffineTransformMakeScale(10, 10);
        self.trackActivityButton.transform = CGAffineTransformMakeTranslation(0, -25);
        self.trackFoodButton.transform = CGAffineTransformMakeTranslation(0, -25);
        self.trackWeightButton.transform = CGAffineTransformMakeTranslation(0, 50);
        self.trackWeightButton.alpha = 1;
        self.trackFoodButton.alpha = 1;
        self.trackActivityButton.alpha = 1;
        [overlay removeFromSuperview];
        [self presentViewController:nav animated:NO completion:nil];
        
    }];
}

- (IBAction)onTrackActivity:(id)sender {

    ActivityViewController *activityViewController = [[ActivityViewController alloc] initWithType:@"trackActivity"];

    UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:self.currentBackgroundImage];
    [activityViewController.view addSubview:backgroundImageView];
    [activityViewController.view sendSubviewToBack:backgroundImageView];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:activityViewController];
    //[self presentViewController:nav animated:NO completion:nil];
    
    UIView *overlay = [[UIView alloc] initWithFrame:self.view.frame];
    overlay.backgroundColor = [UIColor blackColor];
    overlay.alpha = 0;
    [self.view addSubview:overlay];
    [self.view bringSubviewToFront:overlay];
    
    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        overlay.alpha = 0.65;
        self.trackWeightButton.transform = CGAffineTransformMakeScale(.1, .1);
        self.trackFoodButton.transform = CGAffineTransformMakeScale(.1, .1);
        self.trackActivityButton.transform = CGAffineTransformMakeTranslation(0, -50);
        self.trackWeightButton.alpha = 0;
        self.trackFoodButton.alpha = 0;
        self.trackActivityButton.alpha = 0;
        
    } completion:^(BOOL finished) {
        self.trackWeightButton.transform = CGAffineTransformMakeScale(10, 10);
        self.trackFoodButton.transform = CGAffineTransformMakeScale(10, 10);
        self.trackActivityButton.transform = CGAffineTransformMakeTranslation(0, 50);
        self.trackWeightButton.alpha = 1;
        self.trackFoodButton.alpha = 1;
        self.trackActivityButton.alpha = 1;
        [overlay removeFromSuperview];
        [self presentViewController:nav animated:NO completion:nil];
        
    }];
}


- (IBAction)onTapParentView:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCloseMenu object:nil];
}

- (void)blurBackground {
    UIImage *bgImage = [Utils screenshot];

    // Tweak these values Nathan!
    UIColor *tintColor = [UIColor colorWithRed:0.157 green:0.204 blue:0.251 alpha:.5];
    self.currentBackgroundImage = [bgImage applyBlurWithRadius:2 tintColor:tintColor saturationDeltaFactor:1 maskImage:nil];
    self.view.backgroundColor = [UIColor colorWithPatternImage:self.currentBackgroundImage];
}


- (void)undoBlurBackground {
    self.view.backgroundColor = [UIColor clearColor];
}


@end
