//
//  PhysicalActivity.m
//  quinoa
//
//  Created by Amie Kweon on 7/14/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "PhysicalActivity.h"
#import "Utils.h"

@interface PhysicalActivity ()

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *blurbLabel;
@property (weak, nonatomic) IBOutlet UIView *divider;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) UIView *contentView;
@end

@implementation PhysicalActivity

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"PhysicalActivity" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        self.contentView = objects[0];
        [self.contentView setFrame:frame];
        [self addSubview:self.contentView];

    }
    return self;
}


- (void)setActivity:(Activity *)activity {
    _activity = activity;

    int minutes = lroundf([self.activity.activityValue floatValue] / 60);
    if (minutes >= 60) {
        float hours = (minutes / 60);
        self.valueLabel.text = [NSString stringWithFormat:@"%g", hours];
        self.unitLabel.text = [NSString stringWithFormat:@"%@ of activity", ((hours < 2) ? @"Hour" : @"Hours")];
    } else {
        self.valueLabel.text = [NSString stringWithFormat:@"%d", minutes];
        self.unitLabel.text = [NSString stringWithFormat:@"%@ of activity", ((minutes < 2) ? @"Minute" : @"Minutes")];
    }
    self.valueLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:38];

    self.descriptionLabel.text = self.activity.descriptionText;
    self.blurbLabel.text = [self getBlurbCopy];
    if ([self.activity.descriptionText length] > 0) {
        self.divider.hidden = NO;
        self.descriptionLabel.hidden = NO;
        self.divider.backgroundColor = [Utils getLightGray];
    }
    [self.valueLabel setTextColor:[Utils getVibrantBlue]];
    [self.unitLabel setTextColor:[Utils getVibrantBlue]];
    self.unitLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:15];
    [self.blurbLabel setTextColor:[Utils getDarkerGray]];
    [self.descriptionLabel setTextColor:[Utils getDarkBlue]];
}

- (NSString *)getBlurbCopy {
    NSString *copy = @"";
    double average = [self.activity.user.averageActivityDuration doubleValue];
    double current = [self.activity.activityValue doubleValue];
    if (average > 0 && current > 0) {
        int diff = abs(average - current);
        NSNumber *diffNumber = [NSNumber numberWithInteger:diff];
        if (average > current) {
            copy = [NSString stringWithFormat:@"%@ less than average", [Utils getFriendlyTime:diffNumber]];
        } else if (average < current) {
            copy = [NSString stringWithFormat:@"%@ more than average", [Utils getFriendlyTime:diffNumber]];
        } else {
            copy = @"Same as the average";
        }
    }
    return copy;
}

- (void)clean {
    self.valueLabel.text = @"000";
    self.unitLabel.text = @"Default value";
    self.blurbLabel.text = @"Default value";
    self.descriptionLabel.text = @"";
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.contentView setFrame:self.frame];
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
