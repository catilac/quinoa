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

- (IBAction)onTrackFood:(id)sender;
- (IBAction)onTrackWeight:(id)sender;
- (IBAction)onTrackActivity:(id)sender;

@end

@implementation FanOutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self.view setBackgroundColor:[UIColor colorWithRed:0.4 green:0.8 blue:0.2 alpha:0.6]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [self blurBackground];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self undoBlurBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTrackFood:(id)sender {
    TrackEatingViewController *trackEatingVC = [[TrackEatingViewController alloc] init];
    [self.navigationController pushViewController:trackEatingVC animated:YES];
}

- (IBAction)onTrackWeight:(id)sender {
    
    ActivityViewController *activityVC = [[ActivityViewController alloc] initWithType:@"trackWeight"];
    CGSize imageSize = CGSizeZero;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    activityVC.image = image;
    //activityVC.backgroundImageView.image = image;
    //activityVC.view.backgroundColor = [UIColor clearColor];
    //[self.view insertSubview:activityVC.view aboveSubview:self.view];

    [self.navigationController pushViewController:activityVC animated:YES];

    
}

- (IBAction)onTrackActivity:(id)sender {
    ActivityViewController *activityVC = [[ActivityViewController alloc] initWithType:@"trackActivity"];
    
    [self.navigationController pushViewController:activityVC animated:YES];
}

- (void)blurBackground {
    UIImage *bgImage = [Utils screenshot];

    // Tweak these values Nathan!
    UIColor *tintColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    bgImage = [bgImage applyBlurWithRadius:10 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}

- (void)undoBlurBackground {
    self.view.backgroundColor = [UIColor clearColor];
}


@end
