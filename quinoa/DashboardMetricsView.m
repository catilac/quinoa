//
//  DashboardMetricsView.m
//  quinoa
//
//  Created by Amie Kweon on 8/2/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "DashboardMetricsView.h"
#import "Utils.h"
#import "UILabel+QuinoaLabel.h"
#import "Activity.h"

@interface DashboardMetricsView ()

@property (strong, nonatomic) UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *mealCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mealUnitLabel;

@property (weak, nonatomic) IBOutlet UILabel *physicalValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *physicalUnitLabel;

@property (weak, nonatomic) IBOutlet UILabel *weightValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightUnitLabel;

@end

@implementation DashboardMetricsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"DashboardMetricsView" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        self.contentView = objects[0];
        [self.contentView setFrame:CGRectMake(0, 0, 320, 115)];
        [self addSubview:self.contentView];
        [self.contentView setBackgroundColor:[Utils getLightGray]];
    }
    return self;
}


- (void)setData:(NSMutableDictionary *)data {
    _data = data;

    NSNumber *mealCount, *physicalDuration, *weight;
    if (data != nil) {
        mealCount = data[@(ActivityTypeEating)];
        physicalDuration = data[@(ActivityTypePhysical)];
        weight = data[@(ActivityTypeWeight)];

        self.mealCountLabel.text = [NSString stringWithFormat:@"%@", mealCount];

        if ([physicalDuration doubleValue] > 0) {
            double hours = floor([physicalDuration doubleValue] / 60);
            if (hours > 1) {
                self.physicalValueLabel.text = [NSString stringWithFormat:@"%g", hours];
                self.physicalUnitLabel.text = @"hr";
            } else {
                self.physicalValueLabel.text = [NSString stringWithFormat:@"%g", [physicalDuration doubleValue]];
                self.physicalUnitLabel.text = @"min";
            }
        } else {
            self.physicalValueLabel.text = @"-";
        }
        if ([weight doubleValue] > 0) {
            self.weightValueLabel.text = [NSString stringWithFormat:@"%.0f", [weight floatValue]];
        } else {
            self.weightValueLabel.text = @"-";
        }

    } else {
       self.mealCountLabel.text = @"-";
        self.physicalValueLabel.text = @"-";
        self.weightValueLabel.text = @"-";
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM d, yyyy"];

    if ([[Utils getSimpleStringFromDate:self.date] isEqualToString:[Utils getSimpleStringFromDate:[NSDate date]]]) {
        self.dateLabel.text = @"Today";
    } else {
        self.dateLabel.text = [dateFormat stringFromDate:self.date];
    }

    self.headerView.backgroundColor = [Utils getGray];
    self.dateLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16.0f];
    self.dateLabel.textColor = [Utils getDarkBlue];

    self.mealCountLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:28.0f];
    self.mealCountLabel.textColor = [Utils getGray];
    self.mealUnitLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f];
    self.mealUnitLabel.textColor = [Utils getGray];

    self.physicalValueLabel.textColor = [Utils getGray];
    self.physicalValueLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:28.0f];
    self.physicalUnitLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f];
    self.physicalUnitLabel.textColor = [Utils getGray];

    self.weightValueLabel.textColor = [Utils getGray];
    self.weightValueLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:28.0f];
    self.weightUnitLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f];
    self.weightUnitLabel.textColor = [Utils getGray];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
