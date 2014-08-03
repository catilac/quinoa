//
//  MealCell.m
//  quinoa
//
//  Created by Amie Kweon on 8/2/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "MealCell.h"
#import "Utils.h"
#import "UIImage+ImageEffects.h"

@interface MealCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (strong, nonatomic) UILabel *mealName;
@end

@implementation MealCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setActivity:(Activity *)activity {
    _activity = activity;

    [Utils loadImageFile:activity.image inImageView:self.imageView callback:nil];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"ha"];
    self.timestamp.text = [dateFormat stringFromDate:self.activity.createdAt];
    self.timestamp.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:13.0f];

    self.mealName = [[UILabel alloc] initWithFrame:CGRectMake(5, 14, 50, 30)];
    self.mealName.text = [NSString stringWithFormat:@"  %@  ", self.activity.mealName];
    [self.mealName setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f]];
    self.mealName.backgroundColor = [Utils getGreen];
    self.mealName.textColor = [UIColor whiteColor];
    [self.mealName sizeToFit];

    [self addSubview:self.mealName];
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
