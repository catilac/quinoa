//
//  ProfileViewWithActivity.m
//  quinoa
//
//  Created by Amie Kweon on 7/27/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ProfileViewWithActivity.h"
#import "Utils.h"
#import "BTBadgeView.h"
#import "Goal.h"
#import "Activity.h"

@interface ProfileViewWithActivity () {
    float physicalActivityTotal;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *metaLabel;
@property (weak, nonatomic) IBOutlet UIView *divider;
@property (weak, nonatomic) IBOutlet UILabel *physicalActivityLabel;
@property (weak, nonatomic) IBOutlet UIButton *editGoalButton;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *leftStatusLabel;
@property (strong, nonatomic) UILabel *rightStatusLabel;
@property BOOL isGoalEdit;

@end

@implementation ProfileViewWithActivity

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"ProfileViewWithActivity" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        self.contentView = objects[0];
        [self.contentView setFrame:frame];
        [self addSubview:self.contentView];

        // FIXME
        [self.divider setBackgroundColor:[Utils getShadowBlue]];
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;
    self.isGoalEdit = NO;

    self.nameLabel.text = [user getDisplayName];
    self.nameLabel.font = [ UIFont fontWithName: @"SourceSansPro-Semibold" size: 18.0 ];
    self.nameLabel.textColor = [UIColor whiteColor];

    if (user.image) {
        [Utils loadImageFile:user.image inImageView:self.imageView withAnimation:NO];
    } else {
        [self.imageView setImage:[user getPlaceholderImage]];
    }
    self.metaLabel.text = [user getSexAndAge];
    self.metaLabel.font = [ UIFont fontWithName: @"SourceSansPro-Regular" size: 16.0 ];
    self.metaLabel.textColor = [Utils getDarkerGray];
    
    self.chatButton.hidden = !self.isExpertView;
    self.editGoalButton.hidden = !self.isExpertView;

    if (self.isExpertView) {
        self.chatButton.backgroundColor = [Utils getGreen];
        self.chatButton.layer.cornerRadius = 4.0;
        self.chatButton.layer.borderWidth = 2.0;
        self.chatButton.layer.borderColor = [Utils getShadowBlue].CGColor;
        self.chatButton.tintColor = [UIColor whiteColor];

        if (user.newMessageCount) {
            BTBadgeView *badgeView = [[BTBadgeView alloc] initWithFrame:CGRectMake(276, -2, 40, 40)];
            badgeView.shadow = NO;
            badgeView.shine = NO;
            badgeView.fillColor = [Utils getRed];
            badgeView.strokeColor = [Utils getRed];
            badgeView.font = [UIFont fontWithName:@"Helvetica" size:16];
            badgeView.value = [NSString stringWithFormat:@"%@", user.newMessageCount];
            [self addSubview:badgeView];
        }
        [self.editGoalButton addTarget:self action:@selector(showGoalEdit:) forControlEvents:UIControlEventTouchUpInside];
    }

    self.physicalActivityLabel.textColor = [Utils getDarkerGray];
    self.physicalActivityLabel.font = [ UIFont fontWithName: @"SourceSansPro-Regular" size: 16.0 ];
    
    self.editGoalButton.tintColor = [Utils getGreen];
    self.editGoalButton.font = [ UIFont fontWithName: @"SourceSansPro-Regular" size: 16.0 ];
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    [self.contentView setBackgroundColor:[Utils getDarkBlue]];
    
    self.progressView.backgroundColor = [Utils getDarkBlue];

    // This is eventually going to be a custom view chart.
    // == chart starts
    CGFloat percentage = 0.6;
    UIView *chartContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 148, 280, 10)];
    chartContainer.backgroundColor = [Utils getShadowBlue];
    [self addSubview:chartContainer];

    UIView *chartBar = [[UIView alloc] initWithFrame:CGRectMake(20, 148, 280 * percentage, 10)];
    chartBar.backgroundColor = [Utils getVibrantBlue];
    [self addSubview:chartBar];

    if (self.leftStatusLabel != nil) {
        [self.leftStatusLabel removeFromSuperview];
    }
    self.leftStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 100, 18)];
    self.leftStatusLabel.text = @"";
    self.leftStatusLabel.font = [ UIFont fontWithName: @"Helvetica-Bold" size: 24.0 ];
    self.leftStatusLabel.textColor = [Utils getVibrantBlue];
    [self addSubview:self.leftStatusLabel];

    // Need to right align label here
    if (self.rightStatusLabel != nil) {
        [self.rightStatusLabel removeFromSuperview];
    }
    self.rightStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(198, 120, 100, 18)];
    self.rightStatusLabel.text = @"";
    self.rightStatusLabel.font = [ UIFont fontWithName: @"SourceSansPro-Regular" size: 16.0 ];
    self.rightStatusLabel.textAlignment = NSTextAlignmentRight;
    self.rightStatusLabel.textColor = [Utils getDarkerGray];
    [self addSubview:self.rightStatusLabel];
    // == chart ends

    [self fetchGoal];
}

-(void)showGoalEdit:(id)sender {
    UIButton *button = (UIButton *)sender;
    self.isGoalEdit = !self.isGoalEdit;
    if (self.isGoalEdit) {
        [button setTitle:@"Save" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"Edit Goal" forState:UIControlStateNormal];
    }
    if ([self.myDelegate respondsToSelector:@selector(showGoalUIClicked)]) {
        [self.myDelegate showGoalUIClicked];
    }
}

-(void)fetchGoal {
    [Goal getCurrentGoalByUser:self.user success:^(Goal *goal) {
        NSLog(@"[ProfileViewWithActivity goal]: %@", goal);
        NSDate *today = [NSDate date];
        NSDate *weekAgo = [today dateByAddingTimeInterval:-60*60*24*7];
        if (goal != nil) {
            [self fetchActivitiesFrom:goal.startAt to:goal.endAt];
            double diff = (double)[Utils daysBetweenDate:goal.startAt andDate:goal.endAt];
            double targetDuration = diff * [goal.targetDailyDuration doubleValue];
            self.rightStatusLabel.text = [NSString stringWithFormat:@"/ %@", [Utils getFriendlyTime:[NSNumber numberWithDouble:targetDuration]]];
        } else {
            [self fetchActivitiesFrom:weekAgo to:today];
        }
    } error:^(NSError *error) {
        NSLog(@"[ProfileViewWithActivity goal] error: %@", error.description);
    }];
}

- (void)fetchActivitiesFrom:(NSDate *)startDate to:(NSDate *)endDate {
    physicalActivityTotal = 0;

    NSArray *range = [Utils getDateRangeFrom:startDate to:endDate];

    [Activity getActivityByUser:self.user
                      startDate:range[0]
                        endDate:range[1]
                        success:^(NSArray *objects) {
                            for (Activity *activity in objects) {
                                if (activity.activityType == ActivityTypePhysical) {
                                    physicalActivityTotal += [activity.activityValue doubleValue];
                                }
                            }
                            self.leftStatusLabel.text = [Utils getFriendlyTime:[NSNumber numberWithFloat:physicalActivityTotal]];
                        } error:^(NSError *error) {
                            NSLog(@"ProfileViewWithActivity: physical %@", error.description);
                        }];
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
