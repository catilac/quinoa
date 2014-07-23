//
//  DashboardViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/15/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "DashboardViewController.h"
#import "UserHeader.h"
#import "User.h"
#import "ActivityLike.h"
#import "ActivityLikeCell.h"
#import "Utils.h"
#import "PNChart.h"
#import "UILabel+QuinoaLabel.h"

static NSString *LikeCellIdent = @"likeCellIdent";

@interface DashboardViewController ()
{
    CGPoint panStartCoordinate;
    NSString *direction;
}

@property (strong, nonatomic) NSArray *activityLikes;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) User *expert;
@property (strong, nonatomic) UserHeader *expertHeader;

@property (strong, nonatomic) UIView *dashboardHeader;

@property (strong, nonatomic) PNBarChart *barChart;
@property (strong, nonatomic) PNLineChart *physicalChart;

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *weightImage;
@property (weak, nonatomic) IBOutlet UILabel *weightValue;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@property (weak, nonatomic) IBOutlet UILabel *activityValue;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@property (weak, nonatomic) IBOutlet UIImageView *kudosImage;
@property (weak, nonatomic) IBOutlet UILabel *kudosValue;
@property (weak, nonatomic) IBOutlet UILabel *kudosLabel;

@end

@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _user = [User currentUser];
        _expert = _user.currentTrainer;
        [_expert fetch];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Charts
    [self fetchPhysicalStats];
    [self fetchWeightStats];
    [self fetchActivityLikes];
    [self setupDashboardHeader];

    self.title = @"Dashboard";
    
    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
}

- (void)setupDashboardHeader {
    // Initialize Container
    CGRect dashFrame = CGRectMake(10, 5, SCREEN_WIDTH-20, 200);
    self.scrollView = [[UIScrollView alloc] initWithFrame:dashFrame];

    self.dashboardHeader = [[UIView alloc] initWithFrame:dashFrame];
    self.dashboardHeader.layer.borderWidth = 1;
    self.dashboardHeader.layer.borderColor = [Utils getGray].CGColor;
    self.dashboardHeader.layer.cornerRadius = 6;
    self.dashboardHeader.clipsToBounds = YES;


    // ============== Page 1: Physical Activity Chart ==============
    UIView *physicalChartView = [[UIView alloc]
                                 initWithFrame:CGRectMake(0, 0, dashFrame.size.width*0.9f, dashFrame.size.height*0.75f)];
    self.physicalChart = [[PNLineChart alloc]
                          initWithFrame:CGRectMake(0, 30, physicalChartView.frame.size.width, physicalChartView.frame.size.height)];
    NSMutableArray *physicalLabels = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"E"];
    for (NSInteger i = -7; i < 0; ++i) {
        NSTimeInterval interval = i * 24 * 60 * 60;
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
        [physicalLabels addObject:[[dateFormatter stringFromDate:date] substringToIndex:1]];
    }
    [self.physicalChart setXLabels:physicalLabels];

    UILabel *physicalChartLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 20)];
    [physicalChartLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    physicalChartLabel.textColor = [Utils getGray];
    physicalChartLabel.text = @"Activity duration in minutes";
    [physicalChartView addSubview:physicalChartLabel];
    [physicalChartView addSubview:self.physicalChart];
    [self.scrollView addSubview:physicalChartView];


    // ============== Page 2: Weight Chart ==============
    CGRect barChartFrame = CGRectMake(dashFrame.size.width, 0, dashFrame.size.width*0.9f, dashFrame.size.height);
    UIView *weightChartView = [[UIView alloc] initWithFrame:barChartFrame];
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 5, dashFrame.size.width*0.9f, dashFrame.size.height * 0.90f)];
    [self.barChart setStrokeColor:[Utils getDarkBlue]];

    UILabel *chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 20)];
    [chartLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    chartLabel.textColor = [Utils getGray];
    chartLabel.text = @"Weight over Last 7 Weeks";

    [weightChartView addSubview:self.barChart];
    [weightChartView addSubview:chartLabel];
    [self.scrollView addSubview:weightChartView];

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height)];
    [self.dashboardHeader addSubview:self.scrollView];

    // Add page control
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, dashFrame.size.height-40, dashFrame.size.width, 50)];
    [self.pageControl setNumberOfPages:2];
    self.pageControl.pageIndicatorTintColor = [Utils getLightGray];
    self.pageControl.currentPageIndicatorTintColor = [Utils getGray];
    [self.dashboardHeader addSubview:self.pageControl];
    [self.pageControl addTarget:self action:@selector(onPageControlClicked:) forControlEvents:UIControlEventValueChanged];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPan:)];
    panGesture.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:panGesture];


    // =============== Initialize Stats Bar ==================
    NSInteger weightDiff = [[self.user getWeightDifference] intValue];
    if (weightDiff >= 0) {
        self.weightValue.text = [NSString stringWithFormat:@"%+ld lbs", (long)weightDiff];
    } else {
        self.weightValue.text = [NSString stringWithFormat:@"%ld lbs", (long)weightDiff];
    }
    
    self.activityValue.text = [self.user hhmmFormatAvgActivityDuration];

    [self.view addSubview:self.dashboardHeader];
}

- (void)fetchWeightStats {
    [Activity getLatestActivityByUser:self.user
                           byActivity:ActivityTypeWeight
                             quantity:7
                              success:^(NSArray *objects) {
                                  NSMutableArray *dataPoints = [[NSMutableArray alloc] init];
                                  for (NSDictionary *weightData in objects) {
                                      NSNumber *weight = [weightData objectForKey:@"activityValue"];
                                      [dataPoints addObject:weight];
                                  }
                                  [self.barChart setYValues:dataPoints];
                                  [self.barChart strokeChart];
                                  
                              } error:^(NSError *error) {
                                  NSLog(@"Error fetching latest weight activities: %@", error);
                              }];
}

- (void)fetchPhysicalStats {
    NSTimeInterval A_WEEK_AGO = -7 * 24 * 60 * 60; // in seconds
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:A_WEEK_AGO];
    NSDate *endDate = [NSDate date];
    [Activity getLatestActivityByUser:self.user
                           byActivity:ActivityTypePhysical
                            startDate: startDate
                              endDate: endDate
                              success:^(NSArray *objects) {
                                  NSMutableArray *dataPoints = [[NSMutableArray alloc] init];
                                  for (NSInteger i = 0; i < 7; ++i) {
                                      [dataPoints addObject:[NSNull null]];
                                  }
                                  for (Activity *activity in objects) {
                                      NSInteger index = [Utils daysBetweenDate:startDate andDate:activity.createdAt];
                                      if (index < [dataPoints count]) {
                                          if ([[dataPoints objectAtIndex:index] isEqual:[NSNull null]]) {
                                              [dataPoints replaceObjectAtIndex:index withObject:activity.activityValue];
                                          } else {
                                              float sum = [[dataPoints objectAtIndex:index] floatValue] + [activity.activityValue floatValue];
                                              [dataPoints replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:sum]];
                                          }
                                      }
                                  }
                                  PNLineChartData *physicalDataPoints = [PNLineChartData new];
                                  physicalDataPoints.color = [Utils getDarkBlue];
                                  physicalDataPoints.itemCount = self.physicalChart.xLabels.count;
                                  physicalDataPoints.getData = ^(NSUInteger index) {
                                      if ([dataPoints[index] isEqual:[NSNull null]]) {
                                          return [PNLineChartDataItem dataItemWithY:0];
                                      } else {
                                          CGFloat yValue = [dataPoints[index] floatValue] / 60;
                                          return [PNLineChartDataItem dataItemWithY:yValue];
                                      }
                                  };
                                  self.physicalChart.chartData = @[physicalDataPoints];
                                  [self.physicalChart strokeChart];
                              } error:^(NSError *error) {
                                 NSLog(@"Error fetching latest physical activities: %@", error.description);
                              }];
}

- (void)fetchActivityLikes {
    [ActivityLike getActivityLikesByUser:self.user success:^(NSArray *activityLikes) {
        self.activityLikes = activityLikes;
        self.kudosValue.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.activityLikes count]];
    } error:^(NSError *error) {
        NSLog(@"Error fetching ActivityLikes %@", error);
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PageControl methods
- (void)onPageControlClicked:(id)sender {
    [self changePage];
}

- (void)changePage {
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)onPan:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.view];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            panStartCoordinate = point;
            break;
        case UIGestureRecognizerStateChanged: {
            float distance = point.x - panStartCoordinate.x;
            if (distance > 0) { // drag right
                direction = @"R";
            } else {
                direction = @"L";
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if ([direction isEqualToString:@"R"]) {
                self.pageControl.currentPage -= 1;
            } else {
                self.pageControl.currentPage += 1;
            }
            [self changePage];
            break;
        }
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
    }
}

@end
