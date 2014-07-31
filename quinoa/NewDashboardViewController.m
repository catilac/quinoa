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

@property (weak, nonatomic) IBOutlet UILabel *dailyMealLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyPhysicalActivityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyWeightLabel;

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
