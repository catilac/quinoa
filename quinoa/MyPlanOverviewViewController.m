//
//  MyPlanOverviewViewController.m
//  quinoa
//
//  Created by Amie Kweon on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "MyPlanOverviewViewController.h"
#import "ExpandCell.h"
#import "Plan.h"
#import "PlanAttribute.h"
#import "PlanActivity.h"
#import "NSDate+dateWith.h"
#import "Utils.h"

@interface MyPlanOverviewViewController ()

@property (nonatomic, strong) Plan *plan;
@property (nonatomic, strong) NSArray *planAttributes;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ExpandCell *stubCell;
@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSMutableDictionary *history;

// Only one row is expanded at a time; keep track of it with this var.
@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@end

@implementation MyPlanOverviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.history = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self populateData];

    [self.tableView registerNib:[UINib nibWithNibName:@"ExpandCell" bundle:nil] forCellReuseIdentifier:@"ExpandCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ExpandCell *)stubCell {
    if (!_stubCell) {
        _stubCell = [self.tableView dequeueReusableCellWithIdentifier:@"ExpandCell"];
    }
    return _stubCell;
}

- (void)configureCell:(ExpandCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.date = self.days[indexPath.row];
    cell.planAttributes = self.planAttributes;
    NSInteger count = [[self.history objectForKey:[Utils getSimpleStringFromDate:cell.date]] intValue];
    if (count > 0 && count == self.planAttributes.count) {
        cell.isCompleted = YES;
    } else {
        cell.isCompleted = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Display one week at a time
    return self.days.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpandCell" forIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath];
    if (self.expandedIndexPath && self.expandedIndexPath.row == indexPath.row) {
        [cell hideTableView:NO];
    } else {
        [cell hideTableView:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.expandedIndexPath && self.expandedIndexPath.row == indexPath.row) {
        self.expandedIndexPath = nil;
    } else {
        self.expandedIndexPath = indexPath;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.expandedIndexPath && self.expandedIndexPath.row == indexPath.row) {
        return 50 + (50 * self.planAttributes.count);
    } else {
        return 50;
    }
}

- (void)populateData {
    // Get one week date range
    NSDate *lastDay = [NSDate date];
    self.days = [[NSMutableArray alloc] init];

    int i;
    for (i=0; i < 7; i++) {
        self.days[i] = [[lastDay dateByAddingTimeInterval:-1*i*24*60*60] dateWithHour:0 minute:0 second:0];
    }

    // Fetch plan and attributes
    [Plan getPlanByUser:[PFUser currentUser] success:^(PFObject *object) {
        self.plan = (Plan *)object;
        [PlanAttribute getPlanAttributesByPlan:self.plan success:^(NSArray *objects){
            self.planAttributes = objects;
            [self fetchActivities];
        } error:^(NSError *error) {
            NSLog(@"[MyPlanOverview] error: %@", error.description);
        }];
    } error:^(NSError *error) {
        NSLog(@"[MyPlanOverview] error: %@", error.description);
    }];
}

- (void)fetchActivities {
    [PlanActivity getActivitiesByDateRangeFrom:self.days[6] to:self.days[0] success:^(NSArray *activities) {
        // As Parse doesn't support group by, build a dictionary with date as key and count as value
        for (PlanActivity *activity in activities) {
            NSString *key = [Utils getSimpleStringFromDate:activity.date];
            id value = [self.history objectForKey:key];
            NSInteger count = 0;
            if (value) {
                count = [value intValue];
            }
            count += 1;
            [self.history setValue:@(count) forKey:key];
        }
        [self.tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"[MyPlanOverview] error: %@", error.description);
    }];
}

- (void)setupUI {
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

@end
