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
#import "UILabel+QuinoaLabel.h"
#import "UIImage+ImageEffects.h"
#import "Utils.h"

@interface FanOutViewController ()

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
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self blurBackground];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self undoBlurBackground];
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
