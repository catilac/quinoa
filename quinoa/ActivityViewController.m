//
//  ActivityViewController.m
//  quinoa
//
//  Created by Hemen Chhatbar on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ActivityViewController.h"
#import "TrackButton.h"
#import "Activity.h"
#import "User.h"
#import "Utils.h"

// This is an arbitrary number that is going to be used only when
// current user doesn't have weight set.
static const float DEFAULT_WEIGHT = 150.0f;
static const float WEIGHT_MAX_MIN_RANGE = 70.0f;

@interface ActivityViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *slideBarView;
@property (weak, nonatomic) IBOutlet UILabel *activityValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityUnitLabel;
@property (strong, nonatomic) NSString *activityType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slideBarHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (nonatomic, strong) UIView *upArrowView;
@property (nonatomic, strong) UIView *downArrowView;
@property (nonatomic, strong) UIImageView *upArrowImageView;
@property (nonatomic, strong) UIImageView *downArrowImageView;

@property (nonatomic) float activityValue;
@property (nonatomic) float startPosition;
@property (nonatomic) float currentPosition;
@property (nonatomic) float delta;
@property (nonatomic) float incrementQuantity;
@property (strong, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UIView *dividerLine;
@property (nonatomic, assign) BOOL didPan;
@property (nonatomic, assign) BOOL didTouch;

@property (nonatomic, assign) BOOL isActivityValueLabelBig;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
- (IBAction)onSlideBarPan:(UIPanGestureRecognizer *)sender;
- (IBAction)onSlideBarTouch:(id)sender;
- (IBAction)onSlideBarTouchUp:(id)sender;

@end

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.user = [User currentUser];
    }
    return self;
}

- (void)postActivity {
    // Send message to disarm track button
    if ([self.activityType isEqualToString:@"trackWeight"]) {
        [Activity trackWeight:[NSNumber numberWithFloat:self.activityValue]
                     callback:^(BOOL succeeded, NSError *error) {
                         [self.user updateCurrentWeight:[NSNumber numberWithFloat:self.activityValue]];
                         [self dismissModalAndCloseFanOutMenu];
                     }];

    } else if ([self.activityType isEqualToString:@"trackActivity"]) {
        [Activity trackPhysical:[NSNumber numberWithFloat:self.activityValue]
                       callback:^(BOOL succeeded, NSError *error) {
                           [self.user updateAverageActivityDuration];
                           [self dismissModalAndCloseFanOutMenu];
                       }];
    }
}

- (id)initWithType:(NSString *)activityType {
    self = [super init];
    if (self) {
        if([activityType isEqualToString: @"trackWeight"]) {

            self.activityType = @"trackWeight";
            if (self.user && self.user.currentWeight > 0) {
                self.activityValue = [self.user.currentWeight floatValue];
            } else {
                self.activityValue = DEFAULT_WEIGHT;
            }

            self.startPosition = self.activityValue + WEIGHT_MAX_MIN_RANGE;
            self.currentPosition = self.startPosition; //
            self.delta = 0.00f;
            self.incrementQuantity = 0.5f;

        } else if ([activityType isEqualToString: @"trackActivity"]) {

            self.activityType = @"trackActivity";
            self.incrementQuantity = 10;
            self.activityValue = 0;
            self.startPosition = 400.00f;
            self.currentPosition = 400.00f;
            self.delta = 0.00f;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self.activityType isEqualToString: @"trackWeight"]) {
        self.activityValueLabel.text = [NSString stringWithFormat:@"%.2f lbs", self.activityValue];
        //self.title = @"Track Weight";
        //self.activityUnitLabel.text = @"lbs";
        self.hintLabel.text = @"Drag to adjust weight";
    }
    else if ([self.activityType isEqualToString: @"trackActivity"]) {
        self.title = @"Track Activity";
        self.slideBarHeightConstraint.constant = 430;
        //self.activityUnitLabel.text = @"min";
        self.hintLabel.text = @"Drag to adjust activity length";
        self.activityValueLabel.text = [NSString stringWithFormat:@"%0.0f min", self.activityValue];
    }
    

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(postActivity)];

    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(postActivity)];
    
    self.panGestureRecognizer.delegate = self;
    
    self.didPan = 0;
    self.didTouch = 0;
    self.isActivityValueLabelBig = NO;
    
    self.activityValueLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:64];
    self.activityValueLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:64];
    self.activityValueLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.activityValueLabel.layer.transform = CATransform3DScale(self.activityValueLabel.layer.transform, .25, .25, 1);
    self.activityValueLabel.alpha = 0;
    
    self.hintLabel.font = [UIFont fontWithName:@"Source-Sans" size:16];
    self.hintLabel.textColor = [Utils getGray];
    [self hideHint];
    
    // arrows
    UIImage *upArrow = [UIImage imageNamed:@"arrow_up.png"];
    UIImage *downArrow = [UIImage imageNamed:@"arrow_down.png"];
    
    self.upArrowImageView = [[UIImageView alloc] initWithImage:upArrow];
    self.downArrowImageView = [[UIImageView alloc] initWithImage:downArrow];
    self.upArrowView = [[UIView alloc] init];
    self.downArrowView = [[UIView alloc] init];
    CGRect arrowFrame = CGRectMake(self.view.frame.size.width/2 - upArrow.size.width/2, 0, upArrow.size.width, upArrow.size.height);
    CGRect arrowViewFrame = CGRectMake(0, -25, self.view.frame.size.width, upArrow.size.height);
    [self.upArrowImageView setFrame:arrowFrame];
    [self.downArrowImageView setFrame:arrowFrame];
    [self.upArrowView setFrame:arrowViewFrame];
    [self.downArrowView setFrame:arrowViewFrame];
    [self.upArrowView addSubview:self.upArrowImageView];
    [self.downArrowView addSubview:self.downArrowImageView];
    [self.view addSubview:self.upArrowView];
    [self.view addSubview:self.downArrowView];
    [self hideArrow];
    
    
    NSLog(@"bounds %f %f",self.activityValueLabel.bounds.size.width,self.activityValueLabel.bounds.size.height);
    NSLog(@"frame offset: %f %f", self.activityValueLabel.frame.origin.x, self.activityValueLabel.frame.origin.y);
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIView *overlay = [[UIView alloc] initWithFrame:self.view.frame];
    overlay.backgroundColor = [UIColor blackColor];
    overlay.alpha = .65;
    [self.view addSubview:overlay];
    [self.view bringSubviewToFront:overlay];
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        overlay.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:.4 delay:.2 usingSpringWithDamping:.4 initialSpringVelocity:6 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.activityValueLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.activityValueLabel.layer.transform = CATransform3DScale(self.activityValueLabel.layer.transform, 2, 2, 1);
        self.activityValueLabel.alpha = 1;

    } completion:^(BOOL finished){
        [overlay removeFromSuperview];
    }];
    
}

- (void)viewDidLayoutSubviews {
    if ([self.activityType isEqualToString: @"trackWeight"]) {
        NSLog(@"trackWeight");

        self.dividerLine.frame = CGRectMake(self.dividerLine.frame.origin.x, 240, self.dividerLine.frame.size.width, self.dividerLine.frame.size.height);
    }
    else if ([self.activityType isEqualToString: @"trackActivity"]) {
        NSLog(@"trackActivity");

        self.slideBarView.center = CGPointMake(self.slideBarView.center.x, 400);
        self.dividerLine.frame = CGRectMake(self.dividerLine.frame.origin.x, 476, self.dividerLine.frame.size.width, self.dividerLine.frame.size.height);
    }
    [self showHint];
    [self showArrow];
}


- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotReadyToSubmitMessage object:nil];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSlideBarPan:(UIPanGestureRecognizer *)sender {
    
//    NSLog(@"on pan.....");
    self.didPan = 1;

    CGPoint translation = [sender translationInView:self.view];
    //NSLog(@"position %f", sender.view.center.y + translation.y);
        
        if (sender.state == UIGestureRecognizerStateChanged)  {
                
            if(sender.view.center.y + translation.y >= 100 && sender.view.center.y + translation.y <= 480)
                {
                
                //NSLog(@"position %f", sender.view.center.y + translation.y);
                sender.view.center = CGPointMake(sender.view.center.x,sender.view.center.y + translation.y);
                self.currentPosition += translation.y;
                //NSLog(@"start position %f", self.startPosition);
                //NSLog(@"current position %f", self.currentPosition);
                
                
                if(abs(self.startPosition - self.currentPosition) >= 10.00f){
                    if((self.startPosition - self.currentPosition) > 0)
                        self.activityValue += self.incrementQuantity;
                    else
                        self.activityValue -= self.incrementQuantity;
                    
                    // decimals for weight
                    if ([self.activityType isEqualToString: @"trackWeight"]) {
                        self.activityValueLabel.text = [NSString stringWithFormat:@"%.2f lbs", self.activityValue];
                    }
                    // no decimals for time
                    else if ([self.activityType isEqualToString: @"trackActivity"]) {
                        self.activityValueLabel.text = [NSString stringWithFormat:@"%0.0f min", self.activityValue];
                    }
                    
                    self.startPosition = self.currentPosition;
                }
                
                [sender setTranslation:CGPointZero inView:self.view];
            }
        }
        
        else if (sender.state == UIGestureRecognizerStateEnded) {
            //NSLog(@"ended...");
            //self.startPosition = self.currentPosition;
            
            if (self.isActivityValueLabelBig) {
                [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    
                    //self.activityValueLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
                    self.activityValueLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
                    self.activityValueLabel.layer.transform = CATransform3DTranslate(self.activityValueLabel.layer.transform, 47.0, 1, 1);
                    self.activityValueLabel.layer.transform = CATransform3DScale(self.activityValueLabel.layer.transform, .66, .66, 1);
                    self.isActivityValueLabelBig = NO;
                    
                } completion:^(BOOL finished) {
                    [self showHint];
                    [self showArrow];
                }];
            }
            
            self.didPan = 0;
        }
        else if (sender.state == UIGestureRecognizerStateFailed) {
            NSLog(@"cancelled...");
            //self.startPosition = self.currentPosition;
            
            
            if (self.isActivityValueLabelBig) {
                [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    
                    //self.activityValueLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
                    self.activityValueLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
                    self.activityValueLabel.layer.transform = CATransform3DTranslate(self.activityValueLabel.layer.transform, 47.0, 1, 1);
                    self.activityValueLabel.layer.transform = CATransform3DScale(self.activityValueLabel.layer.transform, .66, .66, 1);
                    self.isActivityValueLabelBig = NO;
                    
                } completion:^(BOOL finished) {
                    [self showHint];
                    [self showArrow];
                }];
            }
            
            self.didPan = 0;
        }
    

}


- (IBAction)onSlideBarTouch:(id)sender {
    
    NSLog(@"touch");
    
    self.didTouch = 1;
    
    if (!self.isActivityValueLabelBig) {
        [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:8 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            //self.activityValueLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.activityValueLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
            self.activityValueLabel.layer.transform = CATransform3DTranslate(self.activityValueLabel.layer.transform, -70.0, 1, 1);
            self.activityValueLabel.layer.transform = CATransform3DScale(self.activityValueLabel.layer.transform, 1.5, 1.5, 1);
            self.activityValueLabel.textColor = [UIColor whiteColor];
            [self hideHint];
            [self hideArrow];
            self.isActivityValueLabelBig = YES;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (IBAction)onSlideBarTouchUp:(id)sender {
    
    if(!self.didPan) {
        if (self.isActivityValueLabelBig) {
            [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                self.activityValueLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
                self.activityValueLabel.layer.transform = CATransform3DTranslate(self.activityValueLabel.layer.transform, 47.0, 1, 1);
                self.activityValueLabel.layer.transform = CATransform3DScale(self.activityValueLabel.layer.transform, .66, .66, 1);
                self.isActivityValueLabelBig = NO;
                
            } completion:^(BOOL finished) {
                [self showHint];
                [self showArrow];
            }];
        }
        
        self.didPan = 0;
    }
    
}

- (void)showArrow {
    
    self.upArrowView.frame = CGRectMake(0,
                                      self.slideBarView.frame.origin.y - 20,
                                      self.upArrowView.frame.size.width,
                                        self.upArrowView.frame.size.height);
    
    self.downArrowView.frame = CGRectMake(0,
                                          self.slideBarView.frame.origin.y + self.slideBarView.frame.size.height + self.hintLabel.frame.size.height + 20,
                                          self.downArrowView.frame.size.width,
                                          self.downArrowView.frame.size.height);
    
    [UIView animateWithDuration:.65 delay:0 options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        self.upArrowView.alpha = 1;
        self.downArrowView.alpha = 1;
    } completion:nil
    ];
    
}

- (void)hideArrow {
    
    self.upArrowView.alpha = 0;
    self.downArrowView.alpha = 0;
    
}



- (void)showHint {
    
    self.hintLabel.frame = CGRectMake(self.hintLabel.frame.origin.x,
                                      self.slideBarView.frame.origin.y + self.slideBarView.frame.size.height,
                                      self.hintLabel.frame.size.width,
                                      self.hintLabel.frame.size.height);
    
    
    [UIView animateWithDuration:.75 animations:^{
        self.hintLabel.alpha = 1;
    }];
    
}

- (void)hideHint {
    self.hintLabel.alpha = 0;
}

- (void)cancel {
    [self dismissModalAndCloseFanOutMenu];
}

- (void) dismissModalAndCloseFanOutMenu {
    
    //self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCloseMenu object:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
