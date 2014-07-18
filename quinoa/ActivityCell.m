//
//  ActivityCell.m
//  quinoa
//
//  Created by Amie Kweon on 7/12/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ActivityCell.h"
#import "Utils.h"
#import "PhysicalActivity.h"
#import "DietActivity.h"
#import "WeightActivity.h"
#import "UserHeader.h"

static const CGFloat UserHeaderHeight = 65;
static const CGFloat ActivitySectionHeight = 60;
static const CGFloat DividerHeight = 50;
static const CGFloat ImageDimension = 260;
static const CGFloat CellWidth = 260;

@interface ActivityCell ()

@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation ActivityCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer* layer = self.layer;
        [layer setCornerRadius:3.0f];
        [layer setMasksToBounds:YES];
        [layer setBorderWidth:1.0f];
        [layer setBorderColor:[Utils getGray].CGColor];

        UINib *nib = [UINib nibWithNibName:@"ActivityCell" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        [self addSubview:objects[0]];
    }
    return self;
}

- (void)setActivity:(Activity *)activity {
    _activity = activity;

    if (self.activity.activityType == ActivityTypeEating) {
        DietActivity *dietActivity = [[DietActivity alloc] init];
        dietActivity.activity = activity;
        [self.activityView addSubview:dietActivity];
    } else if (self.activity.activityType == ActivityTypePhysical) {
        PhysicalActivity *physicalActivity = [[PhysicalActivity alloc] init];
        physicalActivity.activity = activity;
        [self.activityView addSubview:physicalActivity];
        [physicalActivity layoutSubviews];
    } else if (self.activity.activityType == ActivityTypeWeight) {
        WeightActivity *weightActivity = [[WeightActivity alloc] init];
        weightActivity.activity = activity;
        [self.activityView addSubview:weightActivity];
    }

    if (self.user == nil) {
        self.topConstraint.constant = 0;
    }
}

- (void)setActivity:(Activity *)activity user:(User *)user {
    _user = user;
    UserHeader *userHeader = [[UserHeader alloc] init];
    self.userView.backgroundColor = [Utils getLightGray];

    userHeader.user = user;
    [self.userView addSubview:userHeader];
    self.userView.hidden = NO;
    self.topConstraint.constant = UserHeaderHeight;

    self.activity = activity;
}

- (CGSize)intrinsicContentSize {
    CGSize size = CGSizeMake(CellWidth, 0);
    if (self.activity.activityType == ActivityTypeEating) {
        size.height += ImageDimension;
    }
    if (self.activity.descriptionText) {
        NSDictionary *dict = @{NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Regular" size:13]};
        CGRect rect = [self.activity.descriptionText boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        size.height += rect.size.height + DividerHeight;
    }
    size.height += ActivitySectionHeight;
    if (self.user) {
        size.height += UserHeaderHeight;
    }
    NSLog(@"type: %i - %f", self.activity.activityType, size.height);
    return size;
}


@end
