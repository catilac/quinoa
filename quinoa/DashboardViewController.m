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

@property (weak, nonatomic) IBOutlet UITableView *feedTable;
@property (strong, nonatomic) NSArray *activityLikes;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) User *expert;
@property (strong, nonatomic) UserHeader *expertHeader;

@property (strong, nonatomic) UIView *dashboardHeader;

@property (strong, nonatomic) PNBarChart *barChart;

@property (strong, nonatomic) UIView *statsBar;
@property (strong, nonatomic) UILabel *weightDifferential;
@property (strong, nonatomic) UILabel *totalActiveTime;
@property (strong, nonatomic) UILabel *numActivityLikes;



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
    [self setupDashboardHeader];
    [self fetchActivityLikes];
    [self fetchWeightStats];
    
}

- (void)setupDashboardHeader {
    // Initialize Container
    CGRect dashFrame = CGRectMake(0, 10, SCREEN_WIDTH, 250);
    self.dashboardHeader = [[UIView alloc] initWithFrame:dashFrame];
    
    // Add Label
    UILabel *chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH, 20)];
    [chartLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f]];
    chartLabel.text = @"Weight over Last 7 Days";
    
    
    // Initialize BarChart
    CGRect barChartFrame = CGRectMake(5, 5, dashFrame.size.width-10, dashFrame.size.height*0.75f);
    self.barChart = [[PNBarChart alloc] initWithFrame:barChartFrame];
    [self.barChart setBackgroundColor:[Utils getLightGray]];
    [self.barChart addSubview:chartLabel];
    [self.dashboardHeader addSubview:self.barChart];

    // Initialize Stats Bar
    CGRect statsFrame = CGRectMake(5, barChartFrame.size.height, dashFrame.size.width-10, dashFrame.size.height*0.25f);
    self.statsBar = [[UIView alloc] initWithFrame:statsFrame];
//    [self.statsBar setBackgroundColor:[Utils getVibrantBlue]];
    
    
    [self.view addSubview:self.dashboardHeader];
    
    [self.view addSubview:self.statsBar];
    
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

- (void)fetchActivityLikes {
    [ActivityLike getActivityLikesByUser:self.user success:^(NSArray *activityLikes) {
        self.activityLikes = activityLikes;
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


@end
