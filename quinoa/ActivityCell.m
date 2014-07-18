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

        // Supposed to fix resizing issue with dequeued cells;
        // I don't think it's helping.
        //self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay]; // force drawRect:
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
}

- (void)setActivity:(Activity *)activity showHeader:(BOOL)showHeader {
    if (showHeader) {
        UserHeader *userHeader = [[UserHeader alloc] init];
        self.userView.backgroundColor = [Utils getLightGray];
        userHeader.user = activity.user;
        [self.userView addSubview:userHeader];
        self.userView.hidden = NO;
        self.topConstraint.constant = UserHeaderHeight;
    } else {
        self.userView.hidden = YES;
        self.topConstraint.constant = 0;
    }
    self.activity = activity;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    NSArray *userViewsToRemove = [self.userView subviews];
    for (UIView *subview in userViewsToRemove) {
        [subview removeFromSuperview];
    }

    NSArray *viewsToRemove = [self.activityView subviews];
    for (UIView *subview in viewsToRemove) {
        [subview removeFromSuperview];
    }

    self.topConstraint.constant = 0;
    self.activity = nil;
}

@end
