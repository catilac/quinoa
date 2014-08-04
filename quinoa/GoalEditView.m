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

@property (weak, nonatomic) IBOutlet UIView *weightSliderView;
@property (weak, nonatomic) IBOutlet UIView *dateSliderView;
@property (weak, nonatomic) IBOutlet UIView *activitySliderView;

@property (weak, nonatomic) IBOutlet UILabel *weightTitle;
@property (weak, nonatomic) IBOutlet UILabel *targetDateTitle;
@property (weak, nonatomic) IBOutlet UILabel *activityDurationTitle;

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
        [self.targetWeightSlider addTarget:self action:@selector(weightSelected:) forControlEvents:UIControlEventTouchDown];
        [self.targetWeightSlider addTarget:self action:@selector(weightDeselected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.targetDateSlider addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [self.targetDateSlider addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventTouchDown];
        [self.targetDateSlider addTarget:self action:@selector(dateDeselected:) forControlEvents:UIControlEventTouchUpInside];

        [self.physicalActivityDurationSlider addTarget:self action:@selector(physicalActivityDurationChanged:) forControlEvents:UIControlEventValueChanged];
        [self.physicalActivityDurationSlider addTarget:self action:@selector(activitySelected:) forControlEvents:UIControlEventTouchDown];
        [self.physicalActivityDurationSlider addTarget:self action:@selector(activityDeselected:) forControlEvents:UIControlEventTouchUpInside];

        self.targetWeightSlider.tag = 0;
        self.targetDateSlider.tag = 1;
        self.physicalActivityDurationSlider.tag = 2;
        
        // styling
        self.contentView.backgroundColor = [Utils getDarkestBlue];
        
        self.weightTitle.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16.0f];
        self.weightTitle.textColor = [Utils getGray];

        self.weightLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0f];
        self.weightLabel.textColor = [Utils getGreen];
        
        self.targetDateTitle.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16.0f];
        self.targetDateTitle.textColor = [Utils getGray];
        
        self.targetDateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0f];
        self.targetDateLabel.textColor = [Utils getGreen];
        
        self.activityDurationTitle.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16.0f];
        self.activityDurationTitle.textColor = [Utils getGray];
        
        self.physicalActivityDurationLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0f];
        self.physicalActivityDurationLabel.textColor = [Utils getGreen];
        
    }
    return self;
}

- (void)setGoal:(Goal *)goal {
    _goal = goal;

    // See here for customizing slider:
    // https://github.com/alskipp/ASValueTrackingSlider/blob/master/README.md
    self.targetWeightSlider.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
    self.targetWeightSlider.popUpViewColor = [Utils getGreenClear];
    self.targetDateSlider.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
    self.targetDateSlider.popUpViewColor = [Utils getGreenClear];
    self.physicalActivityDurationSlider.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
    self.physicalActivityDurationSlider.popUpViewColor = [Utils getGreenClear];

    

    self.weightLabel.text = [NSString stringWithFormat:@"%.0f lbs", [self.user.currentWeight floatValue]];

    NSNumber *weight = [self.user getUserWeight];
    self.targetWeightSlider.maximumValue = [weight floatValue] + 10;
    self.targetWeightSlider.minimumValue = [weight floatValue] - 10;
    [self.targetWeightSlider setValue:(int)[weight floatValue]];
    self.targetWeightSlider.dataSource = self;
    self.targetWeight = weight;

    int defaultDuration = 14;
    self.targetDateLabel.text = [NSString stringWithFormat:@"%d days", defaultDuration];
    self.targetDateSlider.maximumValue = defaultDuration * 2;
    self.targetDateSlider.minimumValue = 0;
    [self.targetDateSlider setValue:defaultDuration];
    self.targetDateSlider.dataSource = self;
    self.targetDate = [NSNumber numberWithInt:defaultDuration];

    int defaultPhysicalDuration = 60 * 60;
    self.physicalActivityDurationLabel.text = [Utils getFriendlyTime:[NSNumber numberWithInt:defaultPhysicalDuration]];
    self.physicalActivityDurationSlider.maximumValue = defaultPhysicalDuration * 2;
    self.physicalActivityDurationSlider.minimumValue = 0;
    [self.physicalActivityDurationSlider setValue:defaultPhysicalDuration];
    self.physicalActivityDurationSlider.dataSource = self;
    self.targetDailyDuration = [NSNumber numberWithInt:defaultPhysicalDuration];
}

- (void)weightChanged:(ASValueTrackingSlider *)slider {
    self.weightLabel.text = [NSString stringWithFormat:@"%.0f lbs", slider.value];
    self.targetWeight = [NSNumber numberWithInt:(int)slider.value];
}

- (void)weightSelected:(ASValueTrackingSlider *)slider {
    
    self.dateSliderView.alpha = 0.24;
    self.activitySliderView.alpha = 0.24;
    self.weightLabel.alpha = 0.24;
}

- (void)weightDeselected:(ASValueTrackingSlider *)slider {
    
    self.dateSliderView.alpha = 1;
    self.activitySliderView.alpha = 1;
    self.weightLabel.alpha = 1;
    
}

- (void)dateChanged:(ASValueTrackingSlider *)slider {
    self.targetDateLabel.text = [NSString stringWithFormat:@"%.0f days", slider.value];
    self.targetDate = [NSNumber numberWithInt:(int)slider.value];
}

- (void)dateSelected:(ASValueTrackingSlider *)slider {
    self.weightSliderView.alpha = 0.24;
    self.activitySliderView.alpha = 0.24;
    
    self.targetDateLabel.alpha = 0.24;
}

- (void)dateDeselected:(ASValueTrackingSlider *)slider {
    self.weightSliderView.alpha = 1;
    self.activitySliderView.alpha = 1;
    
    self.targetDateLabel.alpha = 1;
}

- (void)physicalActivityDurationChanged:(ASValueTrackingSlider *)slider {
    self.physicalActivityDurationLabel.text = [Utils getFriendlyTime:[NSNumber numberWithFloat:slider.value]];
    self.targetDailyDuration = [NSNumber numberWithInt:(int)slider.value];
}

- (void)activitySelected:(ASValueTrackingSlider *)slider {
    
    self.weightSliderView.alpha = 0.24;
    self.dateSliderView.alpha = 0.24;
    self.physicalActivityDurationLabel.alpha = 0.24;
    
}

- (void)activityDeselected:(ASValueTrackingSlider *)slider {
    
    self.weightSliderView.alpha = 1;
    self.dateSliderView.alpha = 1;
    self.physicalActivityDurationLabel.alpha = 1;
    
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
