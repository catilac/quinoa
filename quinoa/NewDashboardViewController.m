//
//  NewDashboardViewController.m
//  quinoa
//
//  Created by Amie Kweon on 7/30/14.
//  Copyright (c) 2014 ;. All rights reserved.
//

#import "NewDashboardViewController.h"
#import "DashboardMetricsView.h"
#import "Activity.h"
#import "Goal.h"
#import "Utils.h"
#import "UILabel+QuinoaLabel.h"

@interface NewDashboardViewController ()

@property (strong, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UILabel *goalDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;

//@property (weak, nonatomic) IBOutlet UILabel *dailyMealLabel;
//@property (weak, nonatomic) IBOutlet UILabel *dailyPhysicalActivityLabel;
//@property (weak, nonatomic) IBOutlet UILabel *dailyWeightLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *mealsLabel;
//@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
//@property (weak, nonatomic) IBOutlet UILabel *poundsLabel;


@property (weak, nonatomic) IBOutlet UIView *goalDaysBar;
@property (weak, nonatomic) IBOutlet UIView *currentDaysBar;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIView *weightview;
@property (weak, nonatomic) IBOutlet UILabel *weightValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UIView *verticalSeparator;

//@property (weak, nonatomic) IBOutlet UIView *metricsHeaderView;
//@property (weak, nonatomic) IBOutlet UIView *metricsView;
//@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UIView *metricsContainerView;

//@property (weak, nonatomic) IBOutlet UIView *leftDividerView;
//@property (weak, nonatomic) IBOutlet UIView *rightDividerView;

@property (strong, nonatomic) Goal *goal;

// Date range used is either current goal range or past 7 days

// Array of dates in the date range
@property (strong, nonatomic) NSMutableArray *dates;

// Map of date to activities
@property (strong, nonatomic) NSMutableDictionary *activitiesByDate;

// A list of weights in the date range
@property (strong, nonatomic) NSMutableArray *weightActivities;

//@property int mealTotal;
@property double physicalActivityTotal;

@end

@implementation NewDashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.user = [User currentUser];
        //self.mealTotal = 0;
        self.physicalActivityTotal = 0;
        self.dates = [NSMutableArray array];
        self.activitiesByDate = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
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
    self.weightview.backgroundColor = [Utils getDarkBlue];
    self.weightValueLabel.textColor = [Utils getVibrantBlue];
    self.weightLabel.textColor = [Utils getGray];
    
    // activity view
    self.activityView.backgroundColor = [Utils getDarkBlue];
    self.activityValueLabel.textColor = [Utils getGreen];
    self.activityLabel.textColor = [Utils getGray];

    self.verticalSeparator.backgroundColor = [Utils getDarkestBlue];
}

- (void)viewDidAppear:(BOOL)animated {
    [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
    NSDate *today = [NSDate date];
    NSDate *weekAgo = [today dateByAddingTimeInterval:-60*60*24*7];

    [Goal getCurrentGoalByUser:self.user success:^(Goal *goal) {
        if (goal) {
            self.goal = goal;
            [self fetchActivitiesFrom:goal.startAt to:goal.endAt];
        } else {
            [self fetchActivitiesFrom:weekAgo to:today];
        }
    } error:^(NSError *error) {
        NSLog(@"NewDashboardViewController goal: %@", error.description);
    }];
}

- (void)fetchActivitiesFrom:(NSDate *)startDate to:(NSDate *)endDate {
    NSArray *range = [Utils getDateRangeFrom:startDate to:endDate];

    // Populate self.dates array
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];

    [self.dates addObject:range[0]];
    NSDate *currentDate = range[0];
    NSDate *toDate = range[1];
    NSDate *today = [NSDate date];
    currentDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    while ([toDate compare: currentDate] != NSOrderedAscending &&
           [today compare: currentDate] != NSOrderedAscending) {
        [self.dates addObject: currentDate];
        currentDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    }

    [Activity getActivityByUser:self.user
                      startDate:range[0]
                        endDate:range[1]
                        success:^(NSArray *objects) {
                            NSLog(@"NewDashboardViewController count: %d", objects.count);
                            for (Activity *activity in objects) {
                                NSString *dateKey = [Utils getSimpleStringFromDate:activity.createdAt];
                                NSMutableDictionary *daily = [self.activitiesByDate objectForKey:dateKey];
                                if (!daily) {
                                    daily = [NSMutableDictionary dictionary];
                                    [daily setObject:@(0) forKey:@(ActivityTypeEating)];
                                    [daily setObject:@(0) forKey:@(ActivityTypePhysical)];
                                    [daily setObject:@(0) forKey:@(ActivityTypeWeight)];
                                }
                                if (activity.activityType == ActivityTypePhysical) {
                                    double currentValue = [[daily objectForKey:@(ActivityTypePhysical)] doubleValue] + [activity.activityValue doubleValue];
                                    [daily setObject:@(currentValue) forKey:@(ActivityTypePhysical)];
                                    self.physicalActivityTotal += [activity.activityValue doubleValue];
                                } else if (activity.activityType == ActivityTypeEating) {
                                    double currentValue = [[daily objectForKey:@(ActivityTypeEating)] doubleValue] + 1;
                                    [daily setObject:@(currentValue) forKey:@(ActivityTypeEating)];
                                    //self.mealTotal += 1;
                                } else if (activity.activityType == ActivityTypeWeight) {
                                    [daily setObject:activity.activityValue forKey:@(ActivityTypeWeight)];
                                }
                                daily[@"date"] = activity.createdAt;
                                [self.activitiesByDate setObject:daily forKey:dateKey];
                            }
                            [self updateUI];
                        } error:^(NSError *error) {
                            NSLog(@"NewDashboardViewController: %@", error.description);
                        }];
}

- (void)updateUI {
    self.weightValueLabel.text = [NSString stringWithFormat:@"%.0f", [self.user.currentWeight floatValue]];
    double hours = floor(self.physicalActivityTotal / 60);
    if (hours > 1) {
        self.activityValueLabel.text = [NSString stringWithFormat:@"%g", hours];
        self.activityLabel.text = @"hr";
    } else {
        self.activityValueLabel.text = [NSString stringWithFormat:@"%g", self.physicalActivityTotal];
        self.activityLabel.text = @"min";
    }
    CGFloat containerWidth = self.view.frame.size.width;

    [Utils removeSubviewsFrom:self.metricsContainerView];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,containerWidth, self.metricsContainerView.frame.size.height)];
    scrollView.pagingEnabled = YES;
    int index = 0;
    for (NSDate *date in self.dates) {
        CGFloat xOffset = index * (int)containerWidth;
        DashboardMetricsView *metricsView = [[DashboardMetricsView alloc]
                                             initWithFrame:CGRectMake(xOffset, 0, containerWidth, self.metricsContainerView.frame.size.height)];
        NSString *dateKey = [Utils getSimpleStringFromDate:date];
        metricsView.date = date;
        metricsView.data = self.activitiesByDate[dateKey];
        [scrollView addSubview:metricsView];
        index++;
    }
    [scrollView setContentSize:CGSizeMake(containerWidth * [self.dates count], self.metricsContainerView.frame.size.height)];
    [scrollView setContentOffset:CGPointMake(containerWidth * ([self.dates count] - 1), 0)];
    [self.metricsContainerView addSubview:scrollView];
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSInteger cellIndex = floor(targetContentOffset->x / 320);
//    if ((targetContentOffset->x - (floor(targetContentOffset->x / 320) * 320)) > 320) {
//        cellIndex++;
//    }
//    targetContentOffset->y = cellIndex * 320;
//}
@end
