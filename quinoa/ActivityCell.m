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
@property (strong, nonatomic) UICollectionViewCell *cell;

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
        CALayer* layer = self.layer;
        [layer setCornerRadius:3.0f];
        [layer setBorderWidth:1.0f];
        [layer setBorderColor:[Utils getGray].CGColor];

        UINib *nib = [UINib nibWithNibName:@"ActivityCell" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];

        self.cell = objects[0];
        [self.contentView addSubview:self.cell];
        [self.cell setFrame:self.contentView.frame];

        self.dietActivity = [[DietActivity alloc] initWithFrame:self.contentView.frame];
        self.physicalActivity = [[PhysicalActivity alloc] initWithFrame:self.contentView.frame];
        self.weightActivity = [[WeightActivity alloc] initWithFrame:self.contentView.frame];
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay]; // force drawRect:
}

- (void)setActivity:(Activity *)activity {
    _activity = activity;

    // When setting activity, make sure it's empty
    [Utils removeSubviewsFrom:self.activityView];

    if (self.activity.activityType == ActivityTypeEating) {
        self.dietActivity.activity = activity;
        [self.activityView addSubview:self.dietActivity];
        [self.dietActivity setNeedsLayout];
    } else if (self.activity.activityType == ActivityTypePhysical) {
        self.physicalActivity.activity = activity;
        [self.activityView addSubview:self.physicalActivity];
        [self.physicalActivity setNeedsLayout];
    } else if (self.activity.activityType == ActivityTypeWeight) {
        self.weightActivity.activity = activity;
        [self.activityView addSubview:self.weightActivity];
        [self.weightActivity setNeedsLayout];
    }
}

- (void)setActivity:(Activity *)activity showHeader:(BOOL)showHeader {
    _showHeader = showHeader;
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

    self.topConstraint.constant = 0;
    self.activity = nil;

    [Utils removeSubviewsFrom:self.userView];
    [Utils removeSubviewsFrom:self.activityView];

    [self.cell setFrame:self.contentView.frame];

    [self.dietActivity clean];
    [self.physicalActivity clean];
    [self.weightActivity clean];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect currentFrame = [self.contentView frame];
    currentFrame.size = [self cellSize];

    self.cell.frame = currentFrame;

    if (self.activity.activityType == ActivityTypeEating) {
        [self.dietActivity setFrame:currentFrame];
        [self.dietActivity layoutSubviews];
    } else if (self.activity.activityType == ActivityTypePhysical) {
        [self.physicalActivity setFrame:currentFrame];
        [self.physicalActivity layoutSubviews];
    } else if (self.activity.activityType == ActivityTypeWeight) {
        [self.weightActivity setFrame:currentFrame];
        [self.weightActivity layoutSubviews];
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


@end
