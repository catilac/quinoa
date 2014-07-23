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
static const CGFloat ActivitySectionHeight = 65;
static const CGFloat DividerHeight = 15;
static const CGFloat ImageDimension = 290;
static const CGFloat ContainerWidth = 300;

@interface ActivityCell ()

@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) UICollectionViewCell *containerCell;

@property (strong,nonatomic) DietActivity *dietActivity;
@property (strong,nonatomic) PhysicalActivity *physicalActivity;
@property (strong,nonatomic) WeightActivity *weightActivity;

@property BOOL showHeader;
@end

@implementation ActivityCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showHeader = YES;

        CALayer* layer = self.layer;
        [layer setCornerRadius:3.0f];
        [layer setBorderWidth:1.0f];
        [layer setBorderColor:[Utils getGray].CGColor];

        UINib *nib = [UINib nibWithNibName:@"ActivityCell" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];

        self.containerCell = objects[0];
        [self.contentView addSubview:self.containerCell];
        [self.containerCell setFrame:self.contentView.frame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay]; // force drawRect:
}

- (void)setActivity:(Activity *)activity {
    _activity = activity;

    // When setting activity, make sure it's empty
    [Utils removeSubviewsFrom:self.activityView];

    if (self.activity.activityType == ActivityTypeEating) {
        if (self.dietActivity == nil) {
            self.dietActivity = [[DietActivity alloc] initWithFrame:[self activityFrame]];
        }
        self.dietActivity.activity = activity;
        [self.activityView addSubview:self.dietActivity];
        [self.dietActivity setNeedsLayout];
    } else if (self.activity.activityType == ActivityTypePhysical) {
        if (self.physicalActivity == nil) {
            self.physicalActivity = [[PhysicalActivity alloc] initWithFrame:[self activityFrame]];
        }
        self.physicalActivity.activity = activity;
        [self.activityView addSubview:self.physicalActivity];
        [self.physicalActivity setNeedsLayout];
    } else if (self.activity.activityType == ActivityTypeWeight) {
        if (self.weightActivity == nil) {
            self.weightActivity = [[WeightActivity alloc] initWithFrame:[self activityFrame]];
        }
        self.weightActivity.activity = activity;
        [self.activityView addSubview:self.weightActivity];
        [self.weightActivity setNeedsLayout];
    }
}

- (void)setActivity:(Activity *)activity showHeader:(BOOL)showHeader {
    _showHeader = showHeader;
    if (showHeader) {
        UserHeader *userHeader = [[UserHeader alloc] initWithFrame:CGRectMake(0, 0, ContainerWidth, UserHeaderHeight)];
        self.userView.backgroundColor = [Utils getLightGray];
        userHeader.liked = self.liked;
        userHeader.activity = activity;
        userHeader.user = activity.user;

        [self.userView addSubview:userHeader];
        [self.userView setNeedsLayout];
        self.userView.hidden = NO;
        self.topConstraint.constant = UserHeaderHeight;
    } else {
        self.userView.hidden = YES;
        self.topConstraint.constant = 0;
    }
    self.activity = activity;
}

- (void)setActivity:(Activity *)activity showHeader:(BOOL)showHeader showLike:(BOOL)showLike {
    _showHeader = showHeader;
    if (showHeader) {
        UserHeader *userHeader = [[UserHeader alloc] initWithFrame:CGRectMake(0, 0, ContainerWidth, UserHeaderHeight)];
        self.userView.backgroundColor = [Utils getLightGray];
        userHeader.showLike = showLike;
        userHeader.liked = self.liked;
        userHeader.activity = activity;
        userHeader.user = activity.user;

        [self.userView addSubview:userHeader];
        [self.userView setNeedsLayout];
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

    self.topConstraint.constant = 0;
    self.activity = nil;

    [Utils removeSubviewsFrom:self.userView];
    [Utils removeSubviewsFrom:self.activityView];

    [self.containerCell setFrame:self.contentView.frame];

    [self.dietActivity clean];
    [self.physicalActivity clean];
    [self.weightActivity clean];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect currentFrame = [self.contentView frame];
    currentFrame.size = [self cellSize];

    self.containerCell.frame = currentFrame;

    if (self.activity.activityType == ActivityTypeEating) {
        [self.dietActivity setFrame:[self activityFrame]];
        [self.dietActivity layoutSubviews];
    } else if (self.activity.activityType == ActivityTypePhysical) {
        [self.physicalActivity setFrame:[self activityFrame]];
        [self.physicalActivity layoutSubviews];
    } else if (self.activity.activityType == ActivityTypeWeight) {
        [self.weightActivity setFrame:[self activityFrame]];
        [self.weightActivity layoutSubviews];
    }

    if (self.showHeader) {
        [self.userView setNeedsLayout];
    }
    //NSLog(@"layoutSubviews: %@", NSStringFromCGRect(currentFrame));
}

- (CGSize)cellSize {
    CGSize size = CGSizeMake(ContainerWidth, 0);
    if (self.activity.activityType == ActivityTypeEating) {
        size.height += ImageDimension;
    }
    BOOL displayDescription = (self.activity.activityType != ActivityTypeWeight && [self.activity.descriptionText length] > 0);

    if (displayDescription) {
        NSDictionary *dict = @{NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Regular" size:14]};
        CGRect rect = [self.activity.descriptionText
                       boundingRectWithSize:CGSizeMake(ContainerWidth - 20, 0)
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:dict
                       context:nil];
        size.height += rect.size.height + DividerHeight;
    }
    size.height += ActivitySectionHeight;
    if (self.showHeader) {
        size.height += UserHeaderHeight;
    }
    //NSLog(@"type: %i - %f", self.activity.activityType, size.height);
    return size;
}

- (CGRect)activityFrame {
    CGRect frame = self.contentView.frame;
    if (self.showHeader) {
        frame.size.height = frame.size.height - UserHeaderHeight;
    }
    return frame;
}

@end
