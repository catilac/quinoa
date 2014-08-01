//
//  NewDashboardViewController.m
//  quinoa
//
//  Created by Amie Kweon on 7/30/14.
//  Copyright (c) 2014 ;. All rights reserved.
//

#import "NewDashboardViewController.h"
#import "Activity.h"
#import "Goal.h"
#import "Utils.h"
#import "UILabel+QuinoaLabel.h"

@interface NewDashboardViewController ()

@property (strong, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UILabel *goalDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;

@property (weak, nonatomic) IBOutlet UILabel *dailyMealLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyPhysicalActivityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyWeightLabel;

@property (weak, nonatomic) IBOutlet UILabel *mealsLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *poundsLabel;


@property (weak, nonatomic) IBOutlet UIView *goalDaysBar;
@property (weak, nonatomic) IBOutlet UIView *currentDaysBar;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIView *weightview;
@property (weak, nonatomic) IBOutlet UILabel *weightValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@property (weak, nonatomic) IBOutlet UIView *metricsHeaderView;
@property (weak, nonatomic) IBOutlet UIView *metricsView;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;

@property (weak, nonatomic) IBOutlet UIView *leftDividerView;
@property (weak, nonatomic) IBOutlet UIView *rightDividerView;

@property int mealTotal;
@property double physicalActivityTotal;
@end

@implementation NewDashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.user = [User currentUser];
        self.mealTotal = 0;
        self.physicalActivityTotal = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self fetchData];
    
    self.title = @"Dashboard";
    
    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    // current, goal days bar
    self.currentDaysBar.backgroundColor = [Utils getGreen];
    self.goalDaysBar.backgroundColor = [Utils getDarkerGray];
    
    // progress view
    /*self.progressView.backgroundColor = [Utils getDarkestBlue];
    self.goalDayLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16.0f];
    self.goalDayLabel.textColor = [UIColor whiteColor];
    self.goalLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:14.0f];
    self.goalLabel.textColor = [Utils getGray];
    self.progressView.layer.masksToBounds = NO;
    self.progressView.layer.shadowOffset = CGSizeMake(0, 1);
    self.progressView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.progressView.layer.shadowRadius = 1.0;*/
    
    // weight view
    self.weightview.backgroundColor = [Utils getDarkestBlue];
    self.weightValueLabel.textColor = [Utils getVibrantBlue];
    self.weightLabel.textColor = [Utils getGray];
    
    // activity view
    self.activityView.backgroundColor = [Utils getDarkestBlue];
    self.activityValueLabel.textColor = [Utils getGreen];
    self.activityLabel.textColor = [Utils getGray];
    
    // metrics header
    self.metricsHeaderView.backgroundColor = [Utils getGray];
    self.todayLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16.0f];
    self.todayLabel.textColor = [Utils getDarkBlue];
    
    // metrics
    self.metricsView.backgroundColor = [Utils getLightGray];
    self.dailyMealLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:28.0f];
    self.dailyMealLabel.textColor = [Utils getGray];
    self.mealsLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f];
    self.mealsLabel.textColor = [Utils getGray];
    self.dailyPhysicalActivityLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:28.0f];
    self.dailyPhysicalActivityLabel.textColor = [Utils getGray];
    self.minutesLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f];
    self.minutesLabel.textColor = [Utils getGray];
    self.dailyWeightLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:28.0f];
    self.dailyWeightLabel.textColor = [Utils getGray];
    self.poundsLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f];
    self.poundsLabel.textColor = [Utils getGray];
    
    //self.leftDividerView.backgroundColor = [Utils getLightGray];
    //self.rightDividerView.backgroundColor = [Utils getGray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
    NSDate *today = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *start = [calendar components:unitFlags fromDate:today];
    start.hour   = 0;
    start.minute = 0;
    start.second = 0;
    NSDate *startDate = [calendar dateFromComponents:start];

    NSDateComponents *end = [calendar components:unitFlags fromDate:today];
    end.hour   = 23;
    end.minute = 59;
    end.second = 59;
    NSDate *endDate = [calendar dateFromComponents:end];
    [Activity getActivityByUser:self.user
                      startDate:startDate
                        endDate:endDate
                        success:^(NSArray *objects) {
                            NSLog(@"NewDashboardViewController count: %d", objects.count);
                            for (Activity *activity in objects) {
                                if (activity.activityType == ActivityTypePhysical) {
                                    self.physicalActivityTotal += [activity.activityValue doubleValue];
                                } else if (activity.activityType == ActivityTypeEating) {
                                    self.mealTotal += 1;
                                }
                            }
                            [self updateUI];
                        } error:^(NSError *error) {
                            NSLog(@"NewDashboardViewController: %@", error.description);
                        }];
    [Goal getCurrentGoalByUser:self.user
                       success:^(Goal *goal) {
                           NSInteger day = [Utils daysBetweenDate:goal.startAt andDate:today];
                           self.goalDayLabel.text = [NSString stringWithFormat:@"%d day progress", day];
                       }
                         error:^(NSError *error) {

                         }];
}

- (void)updateUI {
    self.dailyMealLabel.text = [NSString stringWithFormat:@"%d", self.mealTotal];
    self.dailyPhysicalActivityLabel.text = [NSString stringWithFormat:@"%g", self.physicalActivityTotal];
}
@end
