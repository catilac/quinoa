//
//  GoalEditView.m
//  quinoa
//
//  Created by Amie Kweon on 7/31/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "GoalEditView.h"
#import "Utils.h"

@interface GoalEditView ()

@property (strong, nonatomic) UIView *contentView;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *targetWeightSlider;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *targetDateSlider;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *physicalActivityDurationSlider;

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *physicalActivityDurationLabel;

@end

@implementation GoalEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"GoalEditView" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        self.contentView = objects[0];
        [self.contentView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.contentView];

        [self.targetWeightSlider addTarget:self action:@selector(weightChanged:) forControlEvents:UIControlEventValueChanged];
        [self.targetDateSlider addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

        [self.physicalActivityDurationSlider addTarget:self action:@selector(physicalActivityDurationChanged:) forControlEvents:UIControlEventValueChanged];

        self.targetWeightSlider.tag = 0;
        self.targetDateSlider.tag = 1;
        self.physicalActivityDurationSlider.tag = 2;
    }
    return self;
}

- (void)setGoal:(Goal *)goal {
    _goal = goal;

    // See here for customizing slider:
    // https://github.com/alskipp/ASValueTrackingSlider/blob/master/README.md

    self.weightLabel.text = [NSString stringWithFormat:@"%.0f lbs", [self.user.currentWeight floatValue]];

    self.targetWeightSlider.maximumValue = [self.user.currentWeight floatValue] + 10;
    self.targetWeightSlider.minimumValue = [self.user.currentWeight floatValue] - 10;
    [self.targetWeightSlider setValue:(int)[self.user.currentWeight floatValue]];
    self.targetWeightSlider.dataSource = self;

    int defaultDuration = 14;
    self.targetDateLabel.text = [NSString stringWithFormat:@"%d days", defaultDuration];
    self.targetDateSlider.maximumValue = defaultDuration * 2;
    self.targetDateSlider.minimumValue = 0;
    [self.targetDateSlider setValue:defaultDuration];
    self.targetDateSlider.dataSource = self;

    int defaultPhysicalDuration = 60 * 60;
    self.physicalActivityDurationLabel.text = [Utils getFriendlyTime:[NSNumber numberWithInt:defaultPhysicalDuration]];
    self.physicalActivityDurationSlider.maximumValue = defaultPhysicalDuration * 2;
    self.physicalActivityDurationSlider.minimumValue = 0;
    [self.physicalActivityDurationSlider setValue:defaultPhysicalDuration];
    self.physicalActivityDurationSlider.dataSource = self;
}

- (void)weightChanged:(ASValueTrackingSlider *)slider {
    self.weightLabel.text = [NSString stringWithFormat:@"%.0f lbs", slider.value];
    self.targetWeight = [NSNumber numberWithInt:(int)slider.value];
}

- (void)dateChanged:(ASValueTrackingSlider *)slider {
    self.targetDateLabel.text = [NSString stringWithFormat:@"%.0f days", slider.value];
    self.targetDate = [NSNumber numberWithInt:(int)slider.value];
}

- (void)physicalActivityDurationChanged:(ASValueTrackingSlider *)slider {
    self.physicalActivityDurationLabel.text = [Utils getFriendlyTime:[NSNumber numberWithFloat:slider.value]];
    self.targetDailyDuration = [NSNumber numberWithInt:(int)slider.value];
}

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value {
    if (slider.tag == 2) {
        return [Utils getFriendlyTime:[NSNumber numberWithFloat:value]];
    } else if (slider.tag == 1) {
        return [NSString stringWithFormat:@"%.0f days", value];
    } else {
        return [NSString stringWithFormat:@"%.0f lbs", value];
    }
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
