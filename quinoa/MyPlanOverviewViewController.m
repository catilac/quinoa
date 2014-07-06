//
//  MyPlanOverviewViewController.m
//  quinoa
//
//  Created by Amie Kweon on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "MyPlanOverviewViewController.h"
#import "ExpandCell.h"

@interface MyPlanOverviewViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ExpandCell *stubCell;
@property (strong, nonatomic) NSMutableArray *days;
@end

@implementation MyPlanOverviewViewController

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

    [self setupUI];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self populateData];

    [self.tableView registerNib:[UINib nibWithNibName:@"ExpandCell" bundle:nil] forCellReuseIdentifier:@"ExpandCell"];
    [self.tableView reloadData];
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Display one week at a time
    return self.days.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpandCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)populateData {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startOfTheWeek;
    NSDate *endOfWeek;
    NSTimeInterval interval;
    [cal rangeOfUnit:NSWeekCalendarUnit
           startDate:&startOfTheWeek
            interval:&interval
             forDate:now];

    endOfWeek = [startOfTheWeek dateByAddingTimeInterval:interval-1];
    self.days = [[NSMutableArray alloc] init];

    int i;
    for (i=0; i < 7; i++) {
        self.days[i] = [endOfWeek dateByAddingTimeInterval:-1*i*24*60*60];
    }
}

- (void)setupUI {
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

@end
