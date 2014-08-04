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
#import "PNChart.h"
#import "UILabel+QuinoaLabel.h"
#import "MealCell.h"
#import "Loading.h"

@interface NewDashboardViewController ()

@property (strong, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UILabel *goalDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;

@property (weak, nonatomic) IBOutlet UIView *goalDaysBar;
@property (weak, nonatomic) IBOutlet UIView *currentDaysBar;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIView *weightview;
@property (weak, nonatomic) IBOutlet UILabel *weightValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UIView *verticalSeparator;

@property (weak, nonatomic) IBOutlet UIView *metricsContainerView;

@property (weak, nonatomic) IBOutlet UIView *mealsView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView; // meals

@property (weak, nonatomic) IBOutlet UIView *emptyStateView;
@property (weak, nonatomic) IBOutlet UILabel *emptyStateHeader;
@property (weak, nonatomic) IBOutlet UILabel *emptyStateDescription;

@property (weak, nonatomic) IBOutlet UILabel *nutritionLabel;
@property (strong, nonatomic) Goal *goal;
@property (strong, nonatomic) NSArray *todayMeals;

@property (strong, nonatomic) PNCircleChart * circleChart;

// Date range used is either current goal range or past 7 days

// Array of dates in the date range
@property (strong, nonatomic) NSMutableArray *dates;

// Map of date to activities
@property (strong, nonatomic) NSMutableDictionary *activitiesByDate;

// A list of weights in the date range
//@property (strong, nonatomic) NSMutableArray *weightActivities;

@property double physicalActivityTotal;

@end

@implementation NewDashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.user = [User currentUser];
        self.physicalActivityTotal = 0;
        self.dates = [NSMutableArray array];
        self.activitiesByDate = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Loading *loadingView = [[Loading alloc] initWithFrame:CGRectMake(0, 0, 320, 259)];
    loadingView.tag = 63;
    
    [loadingView startAnimation];
    [self.view addSubview:loadingView];
    
    self.title = @"Dashboard";
    
    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    // current, goal days bar
    self.currentDaysBar.backgroundColor = [Utils getGreen];
    self.goalDaysBar.backgroundColor = [Utils getGray];
    
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
    self.weightValueLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:36.0];
    self.weightLabel.textColor = [Utils getGray];
    
    // activity view
    self.activityView.backgroundColor = [Utils getDarkBlue];
    self.activityValueLabel.textColor = [Utils getOrange];
    self.activityValueLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:36.0];
    self.activityLabel.textColor = [Utils getGray];

    self.verticalSeparator.backgroundColor = [Utils getDarkestBlue];

    self.emptyStateHeader.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18.0f];
    self.emptyStateHeader.textColor = [Utils getDarkerBlue];
    self.emptyStateDescription.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f];
    self.emptyStateDescription.textColor = [Utils getDarkerGray];

    self.nutritionLabel.textColor = [Utils getDarkBlue];
    self.nutritionLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16.0f];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setItemSize:CGSizeMake(300, 65)];
    [self.collectionView setCollectionViewLayout:flowLayout];

    [self.collectionView registerNib:[UINib nibWithNibName:@"MealCell" bundle:nil]
    forCellWithReuseIdentifier:@"MealCell"];

    UIView *whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundView = whiteView;
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Fetch data");
    [self fetchData];
    
    [UIView animateWithDuration:.55 delay:3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        Loading *viewToRemove = (Loading *)[self.view viewWithTag:63];
        [viewToRemove hideIcons];
        viewToRemove.frame = CGRectMake(0, 259, 320, 1);
        
    } completion:^(BOOL finished) {
        Loading *viewToRemove = (Loading *)[self.view viewWithTag:63];
        [viewToRemove stopActive];
        [viewToRemove.layer removeAllAnimations];
        [viewToRemove removeFromSuperview];
    }];
    
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
    // reset data store
    [self.dates removeAllObjects];
    [self.activitiesByDate removeAllObjects];
    self.physicalActivityTotal = 0;

    NSArray *range = [Utils getDateRangeFrom:startDate to:endDate];
    NSDate *today = [NSDate date];

    // Populate self.dates array
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];

    [self.dates addObject:range[0]];
    NSDate *currentDate = range[0];
    NSDate *toDate = range[1];
    currentDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    while ([toDate compare: currentDate] != NSOrderedAscending &&
           [today compare: currentDate] != NSOrderedAscending) {
        [self.dates addObject: currentDate];
        currentDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    }
    double totalDays = (double)[Utils daysBetweenDate:range[0] andDate:range[1]];

    CGRect currentDayFrame = self.currentDaysBar.frame;
    currentDayFrame.size.width = self.goalDaysBar.frame.size.width * ([self.dates count]/totalDays);
    self.currentDaysBar.frame = currentDayFrame;

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
                                } else if (activity.activityType == ActivityTypeWeight) {
                                    [daily setObject:activity.activityValue forKey:@(ActivityTypeWeight)];
                                }
                                daily[@"date"] = activity.createdAt;
                                [self.activitiesByDate setObject:daily forKey:dateKey];
                            }
                            [self updateUI];
                        } error:^(NSError *error) {
                            NSLog(@"NewDashboardViewController: activities %@", error.description);
                        }];

    [Activity getLatestActivityByUser:self.user
                           byActivity:ActivityTypeWeight
                             quantity:10 success:^(NSArray *objects) {
                                 [self updateWeightChart:objects];
                             } error:^(NSError *error) {

                             }];

    NSArray *todayRange = [Utils getDateRangeFrom:today to:today];
    [Activity getLatestActivityByUser:self.user
                           byActivity:ActivityTypeEating
                            startDate:todayRange[0] endDate:todayRange[1]
                              success:^(NSArray *objects) {
                                  NSLog(@"NewDashboardViewController meals count: %d", objects.count);
                                  self.todayMeals = objects;
                                  [self updateTodaysMeals];
                              } error:^(NSError *error) {
                                  NSLog(@"NewDashboardViewController: eating %@", error.description);
                              }];
}

- (void)updateUI {
    //
    // Weekly history
    //

    [self updatePhysicalChart];

    self.weightValueLabel.text = [NSString stringWithFormat:@"%.0f", [self.user.currentWeight floatValue]];
    double hours = floor(self.physicalActivityTotal / 3600);
    NSLog(@"hours %f", hours);
    
    if (hours > 1) {
        self.activityValueLabel.text = [NSString stringWithFormat:@"%.0f", hours];
        self.activityLabel.text = @"hr";
    } else {
        self.activityValueLabel.text = [NSString stringWithFormat:@"%.0f", (self.physicalActivityTotal / 60)];
        self.activityLabel.text = @"min";
    }

    //
    // Daily history
    //
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

- (void)updateWeightChart:(NSArray *)activities {
    UIView *chartView = [[UIView alloc] initWithFrame:CGRectMake(30, 20, 90, 60)];
    PNLineChart *chart = [[PNLineChart alloc]
                                  initWithFrame:CGRectMake(0, 0, chartView.frame.size.width, chartView.frame.size.height)];
    chart.backgroundColor = [Utils getDarkBlue];
    chart.showLabel = NO;
    NSMutableArray *labels = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d"];
    for (Activity *activity in activities) {
        [labels addObject:[dateFormatter stringFromDate:activity.createdAt]];
    }
    [chart setXLabels:labels];

    PNLineChartData *dataPoints = [PNLineChartData new];
    dataPoints.color = [Utils getVibrantBlue];
    dataPoints.itemCount = [activities count];
    dataPoints.getData = ^(NSUInteger index) {
        Activity *activity = activities[index];
        CGFloat yValue = [activity.activityValue floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    chart.chartData = @[dataPoints];
    [chart strokeChart];

    [chartView addSubview:chart];
    [self.weightview addSubview:chartView];
}

- (void)updatePhysicalChart {
    if (self.circleChart) {
        [self.circleChart removeFromSuperview];
    }

    NSInteger numberOfDays = [Utils daysBetweenDate:self.goal.startAt andDate:self.goal.endAt];
    float targetDurationInSeconds = numberOfDays * [self.goal.targetDailyDuration floatValue];
    
    //NSLog(@"goal: %f",[self.goal.targetDailyDuration floatValue]);
    //NSLog(@"seconds: %f",targetDurationInSeconds);

    float achieved = self.physicalActivityTotal/targetDurationInSeconds;
    //NSLog(@"achieved: %f",achieved);
    
    /*- (id)initWithFrame:(CGRect)frame andTotal:(NSNumber *)total andCurrent:(NSNumber *)current andClockwise:(BOOL)clockwise andShadow:(BOOL)hasBackgroundShadow*/
    
    self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(25, 10, 60, 60) andTotal:[NSNumber numberWithInt:100] andCurrent:[NSNumber numberWithInt:(achieved * 100)] andClockwise:NO andShadow:YES];
    self.circleChart.labelColor = [Utils getOrange];
    self.circleChart.backgroundColor = [UIColor clearColor];
    [self.circleChart setStrokeColor:[Utils getOrange]];
    self.circleChart.lineWidth = @4.0f;
    [self.circleChart strokeChart];

    [self.activityView addSubview:self.circleChart];
}

- (void)updateTodaysMeals {
    if ([self.todayMeals count] == 0) {
        self.emptyStateView.hidden = NO;
        self.mealsView.hidden = YES;
    } else {
        self.emptyStateView.hidden = YES;
        self.mealsView.hidden = NO;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView reloadData];
    }
}

#pragma mark UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.todayMeals.count;
}

#pragma mark UICollectionViewDelegate methods
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MealCell" forIndexPath:indexPath];
    cell.activity = self.todayMeals[indexPath.row];
    return cell;
}

@end
