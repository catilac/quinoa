//
//  ProfileViewWithActivity.m
//  quinoa
//
//  Created by Amie Kweon on 7/27/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ProfileViewWithActivity.h"
#import "Utils.h"

@interface ProfileViewWithActivity ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *metaLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIView *divider;
@property (weak, nonatomic) IBOutlet UILabel *physicalActivityLabel;
@property (weak, nonatomic) IBOutlet UIButton *editGoalButton;

@property (strong, nonatomic) UIView *contentView;

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
        [self.divider setBackgroundColor:[Utils getDarkerGray]];
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;

    self.nameLabel.text = [user getDisplayName];
    self.nameLabel.font = [ UIFont fontWithName: @"SourceSansPro-Semibold" size: 16.0 ];
    self.nameLabel.textColor = [UIColor whiteColor];

    if (user.image) {
        [Utils loadImageFile:user.image inImageView:self.imageView withAnimation:NO];
    } else {
        [self.imageView setImage:[user getPlaceholderImage]];
    }
    self.metaLabel.text = [user getSexAndAge];
    self.metaLabel.font = [ UIFont fontWithName: @"SourceSansPro-Regular" size: 13.0 ];
    self.metaLabel.textColor = [Utils getDarkerGray];

    self.chatButton.backgroundColor = [Utils getGreen];
    self.chatButton.tintColor = [UIColor whiteColor];

    self.physicalActivityLabel.textColor = [UIColor whiteColor];
    self.physicalActivityLabel.font = [ UIFont fontWithName: @"SourceSansPro-Semibold" size: 16.0 ];
    self.editGoalButton.tintColor = [Utils getGreen];
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    [self.contentView setBackgroundColor:[Utils getDarkBlue]];

    // Chart
    UIView *chartContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 130, 280, 10)];
    chartContainer.backgroundColor = [Utils getVibrantBlue];
    [self addSubview:chartContainer];

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
