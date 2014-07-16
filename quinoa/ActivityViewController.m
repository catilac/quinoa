//
//  ActivityViewController.m
//  quinoa
//
//  Created by Hemen Chhatbar on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ActivityViewController.h"
#import "UIImage+ImageEffects.h"
#import "TrackButton.h"
#import "Activity.h"

@interface ActivityViewController ()
@property (weak, nonatomic) IBOutlet UIView *slideBarView;
- (IBAction)onSlideBarPan:(UIPanGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UILabel *activityValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityUnitLabel;
@property (strong, nonatomic) NSString *activityType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slideBarHeightConstraint;


@property (nonatomic) float weight;
@property (nonatomic) float startPosition;
@property (nonatomic) float currentPosition;
@property (nonatomic) float delta;
@property (nonatomic) float incrementQuantity;

@end

@implementation ActivityViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(postActivity)
                                                     name:kSubmitData
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReadyToSubmitMessage object:nil];
    }
    return self;
}

- (void)postActivity {
    // Send message to disarm track button
    if ([self.activityType isEqualToString:@"trackWeight"]) {
        [Activity trackWeight:[NSNumber numberWithFloat:self.weight]];
    } else if ([self.activityType isEqualToString:@"trackActivity"]) {
        [Activity trackPhysical:[NSNumber numberWithFloat:self.weight]];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (id)initWithType:(NSString *)activityType {
    self = [super init];
    if (self) {
        if([activityType isEqualToString: @"trackWeight"])
        {

            self.activityType = @"trackWeight";
            self.weight = 170.0f;
            self.startPosition = 240.00f;
            self.currentPosition = 240.00f;
            self.delta = 0.00f;
            self.incrementQuantity = 0.5f;

        }
        else if ([activityType isEqualToString: @"trackActivity"])
        {

            self.activityType = @"trackActivity";
                self.incrementQuantity = 10;
            self.weight = 0;
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
    
    if([self.activityType isEqualToString: @"trackWeight"])
    {
        self.activityUnitLabel.text = @"lbs";
    }
    else if([self.activityType isEqualToString: @"trackActivity"])
    {
                    self.slideBarHeightConstraint.constant = 430;
        self.activityUnitLabel.text = @"min";
        
        self.slideBarView.center = CGPointMake(self.slideBarView.center.x
                                               , 400);

   //     self.activityValueLabel.text = [NSString stringWithFormat:@"%.2f", self.weight];

    }
    
    self.backgroundImageView.image = self.image;
    UIImage *sourceImage = self.backgroundImageView.image;
     UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.3];
    self.backgroundImageView.image = [sourceImage applyBlurWithRadius:10 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];

    self.activityValueLabel.text = [NSString stringWithFormat:@"%.2f", self.weight];
   
   
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
    
    //NSLog(@"on pan.....");

    CGPoint translation = [sender translationInView:self.view];
    //NSLog(@"position %f", sender.view.center.y + translation.y);
    
    if(sender.view.center.y + translation.y >= 25 && sender.view.center.y + translation.y <= 452)
    {
        
        if (sender.state == UIGestureRecognizerStateChanged)  {
            //NSLog(@"position %f", sender.view.center.y + translation.y);
            sender.view.center = CGPointMake(sender.view.center.x,sender.view.center.y + translation.y);
            self.currentPosition += translation.y;
            //NSLog(@"start position %f", self.startPosition);
            //NSLog(@"current position %f", self.currentPosition);
            
            
            if(abs(self.startPosition - self.currentPosition) >= 10.00f){
                if((self.startPosition - self.currentPosition) > 0)
                    self.weight += self.incrementQuantity;
                else
                    self.weight -= self.incrementQuantity;
                self.activityValueLabel.text = [NSString stringWithFormat:@"%.2f", self.weight];
                self.startPosition = self.currentPosition;
            }
            
            [sender setTranslation:CGPointZero inView:self.view];
        }
        
        else if (sender.state == UIGestureRecognizerStateEnded) {
            //NSLog(@"ended...");
            //self.startPosition = self.currentPosition;
            
        }
    }
    
}
@end
