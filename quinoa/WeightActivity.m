//
//  WeightActivity.m
//  quinoa
//
//  Created by Amie Kweon on 7/14/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "WeightActivity.h"
#import "Utils.h"

@interface WeightActivity ()

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *blurbLabel;

@property (strong, nonatomic) UIView *contentView;
@end

@implementation WeightActivity

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"WeightActivity" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        self.contentView = objects[0];
        [self.contentView setFrame:frame];
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)setActivity:(Activity *)activity {
    _activity = activity;

    self.valueLabel.text = [NSString stringWithFormat:@"%i", [self.activity.activityValue intValue]];
    [self.valueLabel setTextColor:[Utils getGreen]];
    [self.unitLabel setTextColor:[Utils getGreen]];
    [self.blurbLabel setTextColor:[Utils getGray]];
    self.valueLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:38];
}

- (void)clean {
    self.valueLabel.text = @"000";
    self.unitLabel.text = @"Default value";
    self.blurbLabel.text = @"Default value";
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
