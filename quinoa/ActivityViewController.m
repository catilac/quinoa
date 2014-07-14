//
//  ActivityViewController.m
//  quinoa
//
//  Created by Hemen Chhatbar on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ActivityViewController.h"

@interface ActivityViewController ()
@property (weak, nonatomic) IBOutlet UIView *slideBarView;
- (IBAction)onSlideBarPan:(UIPanGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UILabel *activityValueLabel;

@property (nonatomic) float weight;
@property (nonatomic) float startPosition;
@property (nonatomic) float currentPosition;
@property (nonatomic) float delta;

@end

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.weight = 175.00f;
    self.startPosition = 240.00f;
    self.currentPosition = 240.00f;
    self.delta = 0.00f;
    self.activityValueLabel.text = [NSString stringWithFormat:@"%.2f", self.weight];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSlideBarPan:(UIPanGestureRecognizer *)sender {
    
    NSLog(@"on pan.....");
    //CGPoint point = [sender translationInView:self.view];
    //sender.view.center = point;
    CGPoint translation = [sender translationInView:self.view];
    NSLog(@"position %f", sender.view.center.y + translation.y);
    
    if(sender.view.center.y + translation.y >= 25 && sender.view.center.y + translation.y <= 452)
    {
        
        if (sender.state == UIGestureRecognizerStateChanged)  {
            NSLog(@"position %f", sender.view.center.y + translation.y);
            sender.view.center = CGPointMake(sender.view.center.x,sender.view.center.y + translation.y);
            self.currentPosition += translation.y;
            NSLog(@"start position %f", self.startPosition);
            NSLog(@"current position %f", self.currentPosition);
            
            
            if(abs(self.startPosition - self.currentPosition) >= 10.00f){
                if((self.startPosition - self.currentPosition) > 0)
                    self.weight += 0.5f;
                else
                    self.weight -= 0.5;
                self.activityValueLabel.text = [NSString stringWithFormat:@"%.2f", self.weight];
                self.startPosition = self.currentPosition;
            }
            
            [sender setTranslation:CGPointZero inView:self.view];
        }
        
        else if (sender.state == UIGestureRecognizerStateEnded) {
            NSLog(@"ended...");
            //self.startPosition = self.currentPosition;
            
        }
    }
    
}
@end
