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
    
    // hide compose buttons
    self.trackWeightButton.frame = CGRectMake(130, self.view.frame.size.height - 30, 60, 60);
    self.trackActivityButton.frame = CGRectMake(130, self.view.frame.size.height - 30, 60, 60);
    self.trackFoodButton.frame = CGRectMake(130, self.view.frame.size.height - 30, 60, 60);
}
- (void)viewWillAppear:(BOOL)animated {
    
    // hidden 130, viewheight - 60, 60, 60
    [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.trackWeightButton.frame = CGRectMake(45, self.view.frame.size.height - 140 + 44, 60, 60);
        self.trackActivityButton.frame = CGRectMake(130, self.view.frame.size.height - 185 + 44, 60, 60);
        self.trackFoodButton.frame = CGRectMake(215, self.view.frame.size.height - 140 + 44, 60, 60);
    } completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOpenMenu object:nil];
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self blurBackground];
}

- (void)viewWillDisappear:(BOOL)animated {
    

    
}

- (void)animateFanOutView {
    [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.trackWeightButton.frame = CGRectMake(130, self.view.frame.size.height, 60, 60);
        self.trackActivityButton.frame = CGRectMake(130, self.view.frame.size.height, 60, 60);
        self.trackFoodButton.frame = CGRectMake(130, self.view.frame.size.height, 60, 60);
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
    [self.navigationController pushViewController:trackEatingVC animated:YES];
}

- (IBAction)onTrackWeight:(id)sender {
    
    ActivityViewController *trackViewController = [[ActivityViewController alloc] initWithType:@"trackWeight"];

    UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:self.currentBackgroundImage];
    [trackViewController.view addSubview:backgroundImageView];
    [trackViewController.view sendSubviewToBack:backgroundImageView];
    [self.navigationController pushViewController:trackViewController animated:NO];
}

- (IBAction)onTrackActivity:(id)sender {

    ActivityViewController *activityViewController = [[ActivityViewController alloc] initWithType:@"trackActivity"];

    UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:self.currentBackgroundImage];
    [activityViewController.view addSubview:backgroundImageView];
    [activityViewController.view sendSubviewToBack:backgroundImageView];
    [self.navigationController pushViewController:activityViewController animated:NO];
}

- (void)blurBackground {
    if (self.currentBackgroundImage == nil) {
        UIImage *bgImage = [Utils screenshot];

        // Tweak these values Nathan!
        UIColor *tintColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        self.currentBackgroundImage = [bgImage applyBlurWithRadius:10 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:self.currentBackgroundImage];
}

- (void)undoBlurBackground {
    self.view.backgroundColor = [UIColor clearColor];
}


@end
