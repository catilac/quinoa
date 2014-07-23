//
//  DietActivity.m
//  quinoa
//
//  Created by Amie Kweon on 7/14/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "DietActivity.h"
#import "Utils.h"

@interface DietActivity ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *divider;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *mealName;
@end

@implementation DietActivity

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"DietActivity" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        self.contentView = objects[0];
        [self.contentView setFrame:frame];
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)setActivity:(Activity *)activity {
    _activity = activity;

    if (self.activity.image) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [Utils loadImageFile:self.activity.image inImageView:self.imageView withAnimation:YES];

        self.mealName = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 50, 30)];
        self.mealName.text = [NSString stringWithFormat:@"  %@  ", self.activity.mealName];
        [self.mealName setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
        self.mealName.backgroundColor = [Utils getGreen];
        self.mealName.textColor = [UIColor whiteColor];
        [self.mealName sizeToFit];

        [self addSubview:self.mealName];
    }
    self.descriptionLabel.text = self.activity.descriptionText;
    [self.descriptionLabel setTextColor:[Utils getDarkBlue]];
    if ([self.activity.descriptionText length] > 0) {
        self.divider.hidden = NO;
        self.descriptionLabel.hidden = NO;
        self.divider.backgroundColor = [Utils getLightGray];
    } else {
        self.divider.hidden = YES;
        self.descriptionLabel.hidden = YES;
    }
}

- (void)clean {
    self.descriptionLabel.text = @"";
    self.mealName.text = @"";
    [self.mealName sizeToFit];
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
