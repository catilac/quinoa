//
//  ExpandCell.m
//  quinoa
//
//  Created by Amie Kweon on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ExpandCell.h"
#import "PlanAttribute.h"
#import "PlanActivity.h"

@interface ExpandCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *checked;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@end

@implementation ExpandCell

- (void)awakeFromNib
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.checked = [[NSMutableDictionary alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDate:(NSDate *)date {
    _date = date;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMM dd yyyy"];
    self.dateLabel.text = [dateFormatter stringFromDate:self.date];
}

- (void)setIsCompleted:(BOOL)isCompleted {
    _isCompleted = isCompleted;
    self.checkLabel.hidden = !_isCompleted;
}

- (void)hideTableView:(BOOL)hide {
    self.tableView.hidden = hide;

    if (!hide) {
        [self fetchActivities];
    }
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

- (void)fetchActivities {
    [PlanActivity getActivitiesByDate:self.date success:^(NSArray *activities) {
        [self.checked removeAllObjects];
        for (PlanActivity *activity in activities) {
            [self.checked setValue:@"" forKey:activity.attributeId];
        }
        [self.tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"[MyPlan] error: %@", error.description);
    }];
}


@end
