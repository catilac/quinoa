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


@property (weak, nonatomic) IBOutlet UIView *trackWeightButton;
@property (weak, nonatomic) IBOutlet UILabel *trackWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackWeightDescription;

@property (weak, nonatomic) IBOutlet UIView *trackActivityButton;
@property (weak, nonatomic) IBOutlet UILabel *trackActivityLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackActivityDescription;

@property (weak, nonatomic) IBOutlet UIView *trackFoodButton;
@property (weak, nonatomic) IBOutlet UILabel *trackFoodLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackFoodDescription;

@property (strong, nonatomic) UIImage *currentBackgroundImage;
@property (strong, nonatomic) UIImagePickerController *camera;

@property (strong, nonatomic) UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UIView *imagePreviewContainer;


@property (strong, nonatomic) NSData *imageData;
@property (assign) Boolean imageSet;
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
    
    // Do any additional setup after lƒbluroading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(animateFanOutView)
                                                 name:kCloseMenu
                                               object:nil];
    
    // Style Activity Buttons
    
    self.trackWeightButton.layer.cornerRadius = 3;
    self.trackActivityButton.layer.cornerRadius = 3;
    self.trackFoodButton.layer.cornerRadius = 3;
    
    self.trackWeightLabel.textColor = [Utils getVibrantBlue];
    self.trackActivityLabel.textColor = [Utils getOrange];
    self.trackFoodLabel.textColor = [Utils getGreen];
    
    self.trackWeightDescription.textColor = [Utils getDarkerGray];
    self.trackActivityDescription.textColor = [Utils getDarkerGray];
    self.trackFoodDescription.textColor = [Utils getDarkerGray];
    
    // Set buttons offscreen
    self.trackWeightButton.frame = CGRectMake(self.trackWeightButton.frame.origin.x, 568, self.trackWeightButton.frame.size.width, self.trackWeightButton.frame.size.height);
    self.trackActivityButton.frame = CGRectMake(self.trackActivityButton.frame.origin.x, 568, self.trackActivityButton.frame.size.width, self.trackActivityButton.frame.size.height);
    self.trackFoodButton.frame = CGRectMake(self.trackFoodButton.frame.origin.x, 568, self.trackFoodButton.frame.size.width, self.trackFoodButton.frame.size.height);
}
- (void)viewWillAppear:(BOOL)animated {
    
    // hidden 130, viewheight - 60, 60, 60
//    [UIView animateWithDuration:.6 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:16 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        self.trackWeightButton.frame = CGRectMake(45, self.view.frame.size.height - 100, 60, 60);
//        self.trackActivityButton.frame = CGRectMake(130, self.view.frame.size.height - 100, 60, 60);
//        self.trackFoodButton.frame = CGRectMake(215, self.view.frame.size.height - 100, 60, 60);
//        NSLog(@"View Appeared");
//
    
    [UIView animateWithDuration:.6 delay:.15 usingSpringWithDamping:.9 initialSpringVelocity:18 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.trackWeightButton.frame = CGRectMake(self.trackWeightButton.frame.origin.x, 409, self.trackWeightButton.frame.size.width, self.trackWeightButton.frame.size.height);
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:.6 delay:.075 usingSpringWithDamping:.9 initialSpringVelocity:18 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.trackActivityButton.frame = CGRectMake(self.trackActivityButton.frame.origin.x, 306, self.trackActivityButton.frame.size.width, self.trackActivityButton.frame.size.height);
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:.6 delay:0 usingSpringWithDamping:.9 initialSpringVelocity:18 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.trackFoodButton.frame = CGRectMake(self.trackFoodButton.frame.origin.x, 203, self.trackFoodButton.frame.size.width, self.trackFoodButton.frame.size.height);
    } completion:^(BOOL finished) {
    }];


    
    
    
//    } completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOpenMenu object:nil];
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self blurBackground];

}

- (void)animateFanOutView {
    
    // Animate buttons out
    
    [UIView animateWithDuration:.3 delay:.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.trackFoodButton.frame = CGRectMake(self.trackFoodButton.frame.origin.x, 568, self.trackFoodButton.frame.size.width, self.trackFoodButton.frame.size.height);
    } completion:nil];
    
    [UIView animateWithDuration:.3 delay:.05 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.trackActivityButton.frame = CGRectMake(self.trackActivityButton.frame.origin.x, 568, self.trackActivityButton.frame.size.width, self.trackActivityButton.frame.size.height);
    } completion:nil];
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.trackWeightButton.frame = CGRectMake(self.trackWeightButton.frame.origin.x, 568, self.trackWeightButton.frame.size.width, self.trackWeightButton.frame.size.height);
    } completion:nil];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onTrackFood:(id)sender {
   /* TrackEatingViewController *trackEatingVC = [[TrackEatingViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:trackEatingVC];
    
    [self presentViewController:nav animated:YES completion:nil]; */
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera] == YES){
        
        // Hide Views
        [UIView animateWithDuration:.3 delay:.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.trackWeightButton.frame = CGRectMake(self.trackWeightButton.frame.origin.x, 568, self.trackWeightButton.frame.size.width, self.trackWeightButton.frame.size.height);
        } completion:nil];
        
        [UIView animateWithDuration:.3 delay:.05 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.trackActivityButton.frame = CGRectMake(self.trackActivityButton.frame.origin.x, 568, self.trackActivityButton.frame.size.width, self.trackActivityButton.frame.size.height);
        } completion:nil];
        
        [UIView animateWithDuration:.3 delay:.05 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.trackFoodButton.frame = CGRectMake(self.trackFoodButton.frame.origin.x, self.trackFoodButton.frame.origin.y -10, self.trackFoodButton.frame.size.width, self.trackFoodButton.frame.size.height);
        } completion:^(BOOL finished){
            self.trackFoodButton.frame = CGRectMake(self.trackFoodButton.frame.origin.x, 568, self.trackFoodButton.frame.size.width, self.trackFoodButton.frame.size.height);
        
        }];

        
        // Create image picker controller
        self.camera = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        self.camera.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        self.camera.delegate = self;
        
        // Show image picker
        [self presentViewController:self.camera animated:YES completion:nil];
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Grab the image that was selected
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss the image picker
    //[picker dismissViewControllerAnimated:YES completion:nil];
    [picker dismissModalViewControllerAnimated: NO];
    TrackEatingViewController *trackEatingVC = [[TrackEatingViewController alloc] init];
        trackEatingVC.imageData = UIImageJPEGRepresentation(image, 0.05f);
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:trackEatingVC];


    //self.imageData = UIImageJPEGRepresentation(image, 0.05f);
    
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
        
        [UIView animateWithDuration:.3 delay:.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.trackFoodButton.frame = CGRectMake(self.trackFoodButton.frame.origin.x, 568, self.trackFoodButton.frame.size.width, self.trackFoodButton.frame.size.height);
        } completion:nil];
        
        [UIView animateWithDuration:.3 delay:.05 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.trackActivityButton.frame = CGRectMake(self.trackActivityButton.frame.origin.x, 568, self.trackActivityButton.frame.size.width, self.trackActivityButton.frame.size.height);
        } completion:nil];
        
        [UIView animateWithDuration:.3 delay:.05 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.trackWeightButton.frame = CGRectMake(self.trackWeightButton.frame.origin.x, self.trackWeightButton.frame.origin.y -10, self.trackWeightButton.frame.size.width, self.trackWeightButton.frame.size.height);
        } completion:nil];

        
    } completion:^(BOOL finished) {
        
        self.trackWeightButton.frame = CGRectMake(self.trackWeightButton.frame.origin.x, 568, self.trackWeightButton.frame.size.width, self.trackWeightButton.frame.size.height);

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

        [UIView animateWithDuration:.3 delay:.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.trackFoodButton.frame = CGRectMake(self.trackFoodButton.frame.origin.x, 568, self.trackFoodButton.frame.size.width, self.trackFoodButton.frame.size.height);
        } completion:nil];
        
        [UIView animateWithDuration:.3 delay:.05 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.trackWeightButton.frame = CGRectMake(self.trackWeightButton.frame.origin.x, 568, self.trackActivityButton.frame.size.width, self.trackWeightButton.frame.size.height);
        } completion:nil];
        
        [UIView animateWithDuration:.3 delay:.05 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.trackActivityButton.frame = CGRectMake(self.trackActivityButton.frame.origin.x, self.trackActivityButton.frame.origin.y -10, self.trackActivityButton.frame.size.width, self.trackActivityButton.frame.size.height);
        } completion:nil];


        
    } completion:^(BOOL finished) {

        self.trackActivityButton.frame = CGRectMake(self.trackActivityButton.frame.origin.x, 568, self.trackActivityButton.frame.size.width, self.trackWeightButton.frame.size.height);
        
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
