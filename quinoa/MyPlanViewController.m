//
//  MyPlanViewController.m
//  quinoa
//
//  Created by Amie Kweon on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "MyPlanViewController.h"
#import "MyPlanOverviewViewController.h"
#import "Plan.h"
#import "PlanAttribute.h"
#import "PlanActivity.h"
#import "NSDate+dateWith.h"
#import "Utils.h"

@interface MyPlanViewController ()

@property (nonatomic, strong) Plan *plan;
@property (nonatomic, strong) NSArray *planAttributes;
@property (nonatomic, strong) NSMutableDictionary *checked;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSDate *displayDate;
@end

@implementation MyPlanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"My Plan";
        self.displayDate = [[NSDate date] dateWithHour:0 minute:0 second:0];
        self.checked = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self setupUI];
    [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.planAttributes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckCell"];
    }
    PlanAttribute *attribute = self.planAttributes[indexPath.row];

    if ([self.checked objectForKey:attribute.objectId]) {
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    } else {
        cell.selectionStyle = UITableViewCellAccessoryCheckmark;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = ((PlanAttribute *)self.planAttributes[indexPath.row]).planText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PlanAttribute *attribute = self.planAttributes[indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;

        [PlanActivity removeActivityByAttributeId:attribute.objectId date:self.displayDate];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [PlanActivity addActivityByAttributeId:attribute.objectId date:self.displayDate];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EEEE"];
    cell.textLabel.text = [dayFormatter stringFromDate:self.displayDate];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setTitle:@"<" forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 50, 50);
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(previousDay:) forControlEvents:UIControlEventTouchDown];
    [cell addSubview:leftButton];

    NSDate *today = [NSDate date];
    if (![[Utils getSimpleStringFromDate:today] isEqualToString:[Utils getSimpleStringFromDate:self.displayDate]]) {
        UIButton *rightButton = [[UIButton alloc] init];
        [rightButton setTitle:@">" forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(self.view.frame.size.width - 50, 0, 50, 50);
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(nextDay:) forControlEvents:UIControlEventTouchDown];
        [cell addSubview:rightButton];
    }

    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 320, 1)];
    seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
    [cell addSubview:seperatorView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (void)fetchData {
    [Plan getPlanByUser:[PFUser currentUser] success:^(PFObject *object) {
        self.plan = (Plan *)object;
        [PlanAttribute getPlanAttributesByPlan:self.plan success:^(NSArray *objects){
            self.planAttributes = objects;
            [self fetchActivities];
        } error:^(NSError *error) {
            NSLog(@"[MyPlan] error: %@", error.description);
        }];
    } error:^(NSError *error) {
        NSLog(@"[MyPlan] error: %@", error.description);
    }];
}

- (void)fetchActivities {
    [PlanActivity getActivitiesByDate:self.displayDate success:^(NSArray *activities) {
        [self.checked removeAllObjects];
        for (PlanActivity *activity in activities) {
            [self.checked setValue:@"" forKey:activity.attributeId];
        }
        [self.tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"[MyPlan] error: %@", error.description);
    }];
}
- (void)previousDay:(id)sender {
    self.displayDate = [self.displayDate dateByAddingTimeInterval:-1*24*60*60];
    [self fetchActivities];
}

- (void)nextDay:(id)sender {
    self.displayDate = [self.displayDate dateByAddingTimeInterval:1*24*60*60];
    [self fetchActivities];
}

- (void)setupUI {
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    UIBarButtonItem *overviewButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Overview"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(showOverview)];

    self.navigationItem.rightBarButtonItem = overviewButton;
}

- (void)showOverview {
    MyPlanOverviewViewController *overviewViewController = [[MyPlanOverviewViewController alloc] init];
    [self.navigationController pushViewController:overviewViewController animated:YES];
}
@end
