//
//  ActivityLikeCell.m
//  quinoa
//
//  Created by Chirag Davé on 7/17/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ActivityLikeCell.h"
#import "Activity.h"
#import "Utils.h"

@interface ActivityLikeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *likeTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) ActivityLike *like;

@end

@implementation ActivityLikeCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setActivityLike:(ActivityLike *)like {
    _like = like;
    [self.imageView setContentMode:UIViewContentModeScaleToFill];
    [self.imageView clipsToBounds];
    if (like.activityType == ActivityTypeWeight) {
        // TODO this is horrible copy
        self.message.text = @"Liked your Weight Loss";
        UIImage *composeIcon = [Utils imageWithImage:[UIImage imageNamed:@"composeWeight"] scaledToSize:CGSizeMake(30, 30)];
        [self.imageView setImage:composeIcon];

    } else if (like.activityType == ActivityTypePhysical) {
        self.message.text = @"Liked your Physical Activity";
        UIImage *composeIcon = [Utils imageWithImage:[UIImage imageNamed:@"composeActivity"] scaledToSize:CGSizeMake(30, 30)];
        [self.imageView setImage:composeIcon];

    } else {
        self.imageView.backgroundColor = [UIColor greenColor];
        self.message.text = @"Delicious!";
        UIImage *composeIcon = [Utils imageWithImage:[UIImage imageNamed:@"composeDiet"] scaledToSize:CGSizeMake(30, 30)];
        [self.imageView setImage:composeIcon];
    }
    [self.message setTextColor:[Utils getDarkBlue]];
    self.message.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f];
}

@end
