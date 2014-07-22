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

@property (weak, nonatomic) IBOutlet UITableView *feedTable;
@property (strong, nonatomic) NSArray *activityLikes;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) User *expert;
@property (strong, nonatomic) UserHeader *expertHeader;

@property (strong, nonatomic) UIView *dashboardHeader;

@property (strong, nonatomic) PNBarChart *barChart;
@property (strong, nonatomic) PNLineChart *physicalChart;

@property (strong, nonatomic) UIView *statsBar;
@property (strong, nonatomic) UILabel *weightDifferential;
@property (strong, nonatomic) UILabel *totalActiveTime;
@property (strong, nonatomic) UILabel *numKudos;

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIScrollView *scrollView;

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
    [self.feedTable registerNib:[UINib nibWithNibName:@"ActivityLikeCell" bundle:nil] forCellReuseIdentifier:LikeCellIdent];
    
    self.feedTable.dataSource = self;
    self.feedTable.delegate = self;
    [self.feedTable setSeparatorInset:UIEdgeInsetsZero];

    [self setupFeedTable];
    [self fetchActivityLikes];

    // Charts
    [self fetchPhysicalStats];
    [self fetchWeightStats];
    [self setupDashboardHeader];

    self.title = @"Dashboard";
    
    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
}

- (void)setupDashboardHeader {
    // Initialize Container
    CGRect dashFrame = CGRectMake(10, 5, SCREEN_WIDTH-20, 240);
    self.scrollView = [[UIScrollView alloc] initWithFrame:dashFrame];

    self.dashboardHeader = [[UIView alloc] initWithFrame:dashFrame];
    self.dashboardHeader.layer.borderWidth = 1;
    self.dashboardHeader.layer.borderColor = [Utils getGray].CGColor;
    self.dashboardHeader.layer.cornerRadius = 6;
    self.dashboardHeader.clipsToBounds = YES;


    // ============== Page 1: Physical Activity Chart ==============
    UIView *physicalChartView = [[UIView alloc]
                                 initWithFrame:CGRectMake(0, 0, dashFrame.size.width*0.9f, dashFrame.size.height*0.55f)];
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
    CGRect barChartFrame = CGRectMake(dashFrame.size.width, 0, dashFrame.size.width*0.9f, dashFrame.size.height*0.7f);
    UIView *weightChartView = [[UIView alloc] initWithFrame:barChartFrame];
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 5, dashFrame.size.width*0.9f, dashFrame.size.height*0.7f)];
    [self.barChart setStrokeColor:[Utils getDarkBlue]];
//    [self.barChart setBackgroundColor:[Utils getLightGray]];

    UILabel *chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 20)];
    [chartLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    chartLabel.textColor = [Utils getGray];
    chartLabel.text = @"Weight over Last 7 Days";

    [weightChartView addSubview:self.barChart];
    [weightChartView addSubview:chartLabel];
    [self.scrollView addSubview:weightChartView];

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height)];
    [self.dashboardHeader addSubview:self.scrollView];

    // Add page control
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, dashFrame.size.height*0.62f, dashFrame.size.width, 50)];
    [self.pageControl setNumberOfPages:2];
    self.pageControl.pageIndicatorTintColor = [Utils getLightGray];
    self.pageControl.currentPageIndicatorTintColor = [Utils getGray];
    [self.dashboardHeader addSubview:self.pageControl];
    [self.pageControl addTarget:self action:@selector(onPageControlClicked:) forControlEvents:UIControlEventValueChanged];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPan:)];
    panGesture.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:panGesture];


    // Initialize Stats Bar
    CGRect statsFrame = CGRectMake(11, 13 + barChartFrame.size.height + self.dashboardHeader.frame.origin.y, dashFrame.size.width-2, self.dashboardHeader.frame.size.height - barChartFrame.size.height - 15);
    self.statsBar = [[UIView alloc] initWithFrame:statsFrame];
    self.statsBar.backgroundColor = [UIColor whiteColor];
    self.statsBar.layer.cornerRadius = 6;
    
    // Weight Info
    CGRect weightFrame = CGRectMake(0, 8, statsFrame.size.width/3, 30);
    UIView *weightInfo = [[UIView alloc] initWithFrame:weightFrame];

    self.weightDifferential = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, statsFrame.size.width/3, 24)];
    
    NSInteger weightDiff = [[self.user getWeightDifference] intValue];
    if (weightDiff >= 0) {
        self.weightDifferential.text = [NSString stringWithFormat:@"%+ld lbs", (long)weightDiff];
    } else {
        self.weightDifferential.text = [NSString stringWithFormat:@"%ld lbs", (long)weightDiff];
    }
    
    [self.weightDifferential setFont:[UIFont fontWithName:@"SourceSansPro-Semibold" size:21.0f]];
    self.weightDifferential.textColor = [Utils getDarkBlue];
    self.weightDifferential.textAlignment = NSTextAlignmentCenter;
    //[self.weightDifferential sizeToFit];
    
    UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.weightDifferential.frame.size.height, statsFrame.size.width/3, 16)];
    weightLabel.text = @"Weight";
    weightLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f];
    weightLabel.textColor = [Utils getGray];
    weightLabel.textAlignment = NSTextAlignmentCenter;
    //[weightLabel sizeToFit];
    
    [weightInfo addSubview:self.weightDifferential];
    [weightInfo addSubview:weightLabel];
    [self.statsBar addSubview:weightInfo];
    
    // Total Active Time Label
    CGRect timeFrame = CGRectMake(statsFrame.size.width/3, 8, statsFrame.size.width/3, 30);
    UIView *activeTimeInfo = [[UIView alloc] initWithFrame:timeFrame];
    
    self.totalActiveTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, statsFrame.size.width/3, 24)];
    self.totalActiveTime.text = [self.user hhmmFormatAvgActivityDuration];
    self.totalActiveTime.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:21.0f];
    self.totalActiveTime.textColor = [Utils getDarkBlue];
    self.totalActiveTime.textAlignment = NSTextAlignmentCenter;
    //[self.totalActiveTime sizeToFit];
    
    UILabel *activeTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.totalActiveTime.frame.size.height, statsFrame.size.width/3, 16)];
    activeTimeLabel.text = @"Active Time";
    activeTimeLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f];
    activeTimeLabel.textColor = [Utils getGray];
    activeTimeLabel.textAlignment = NSTextAlignmentCenter;
    //[activeTimeLabel sizeToFit];
    
    [activeTimeInfo addSubview:self.totalActiveTime];
    [activeTimeInfo addSubview:activeTimeLabel];
    [self.statsBar addSubview:activeTimeInfo];
    
    // Number Kudos Label
    CGRect kudosRect = CGRectMake(statsFrame.size.width/3*2, 8, statsFrame.size.width/3, 30);
    UIView *kudosInfo = [[UIView alloc] initWithFrame:kudosRect];
    
    self.numKudos = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, statsFrame.size.width/3, 24)];
    self.numKudos.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.activityLikes count]];
    self.numKudos.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:21.0f];
    self.numKudos.textColor = [Utils getDarkBlue];
    self.numKudos.textAlignment = NSTextAlignmentCenter;
    //[self.numKudos sizeToFit];
    
    UILabel *kudosLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.numKudos.frame.size.height, statsFrame.size.width/3, 16)];
    kudosLabel.text = @"Kudos";
    kudosLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f];
    kudosLabel.textColor = [Utils getGray];
    kudosLabel.textAlignment = NSTextAlignmentCenter;
    //[kudosLabel sizeToFit];
    
    [kudosInfo addSubview:self.numKudos];
    [kudosInfo addSubview:kudosLabel];
    [self.statsBar addSubview:kudosInfo];

    [self.view addSubview:self.dashboardHeader];
    [self.view addSubview:self.statsBar];
}

- (void)setupFeedTable {
    self.feedTable.layer.borderWidth = 1;
    self.feedTable.layer.borderColor = [Utils getGray].CGColor;
    self.feedTable.layer.cornerRadius = 6;
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
                                      if ([[dataPoints objectAtIndex:index] isEqual:[NSNull null]]) {
                                          [dataPoints replaceObjectAtIndex:index withObject:activity.activityValue];
                                      } else {
                                          float sum = [[dataPoints objectAtIndex:index] floatValue] + [activity.activityValue floatValue];
                                          [dataPoints replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:sum]];
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
        self.numKudos.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.activityLikes count]];
        [self.feedTable reloadData];
    } error:^(NSError *error) {
        NSLog(@"Error fetching ActivityLikes %@", error);
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.activityLikes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityLikeCell *cell = (ActivityLikeCell *)[tableView dequeueReusableCellWithIdentifier:LikeCellIdent];
    ActivityLike *like = self.activityLikes[indexPath.row];
    [cell setActivityLike:like];
    return cell;
}

#pragma mark UITableViewDelegate methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.expertHeader = [[UserHeader alloc] init];
    [self.expertHeader setUser:self.expert];
    [self.expertHeader setBackgroundColor:[Utils getGray]];
    return self.expertHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 65;
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
