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

@interface FanOutViewController ()

@property (weak, nonatomic) IBOutlet UIButton *trackFoodButton;

- (IBAction)onTrackFood:(id)sender;
- (IBAction)onTrackWeight:(id)sender;



@end

@implementation FanOutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor colorWithRed:0.4 green:0.8 blue:0.2 alpha:0.6]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    ActivityViewController *activityVC = [[ActivityViewController alloc] init];
    [self.navigationController pushViewController:activityVC animated:YES];

    
}
@end
