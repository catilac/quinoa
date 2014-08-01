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

@interface ProfileViewWithActivity ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *metaLabel;
@property (weak, nonatomic) IBOutlet UIView *divider;
@property (weak, nonatomic) IBOutlet UILabel *physicalActivityLabel;
@property (weak, nonatomic) IBOutlet UIButton *editGoalButton;

@property (strong, nonatomic) UIView *contentView;
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
        [self.divider setBackgroundColor:[Utils getDarkerGray]];
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;
    self.isGoalEdit = NO;

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

    self.chatButton.hidden = !self.isExpertView;
    self.editGoalButton.hidden = !self.isExpertView;

    if (self.isExpertView) {
        self.chatButton.backgroundColor = [Utils getGreen];
        self.chatButton.tintColor = [UIColor whiteColor];

        if (user.newMessageCount) {
            BTBadgeView *badgeView = [[BTBadgeView alloc] initWithFrame:CGRectMake(240, 0, 40, 40)];
            badgeView.value = [NSString stringWithFormat:@"%@", user.newMessageCount];
            [self addSubview:badgeView];
        }
        [self.editGoalButton addTarget:self action:@selector(showGoalEdit:) forControlEvents:UIControlEventTouchUpInside];
    }

    self.physicalActivityLabel.textColor = [UIColor whiteColor];
    self.physicalActivityLabel.font = [ UIFont fontWithName: @"SourceSansPro-Semibold" size: 16.0 ];
    self.editGoalButton.tintColor = [Utils getGreen];
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    [self.contentView setBackgroundColor:[Utils getDarkBlue]];

    // This is eventually going to be a custom view chart.
    // == chart starts
    CGFloat percentage = 0.6;
    UIView *chartContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 130, 280, 10)];
    chartContainer.backgroundColor = [Utils getDarkBlue];
    [self addSubview:chartContainer];

    UIView *chartBar = [[UIView alloc] initWithFrame:CGRectMake(20, 130, 280 * percentage, 10)];
    chartBar.backgroundColor = [Utils getVibrantBlue];
    [self addSubview:chartBar];

    UILabel *leftStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 100, 15)];
    leftStatusLabel.text = @"80/240 mins";
    leftStatusLabel.font = [ UIFont fontWithName: @"SourceSansPro-Regular" size: 13.0 ];
    leftStatusLabel.textColor = [Utils getDarkerGray];
    [self addSubview:leftStatusLabel];

    // Need to right align label here
    UILabel *rightStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 150, 100, 15)];
    rightStatusLabel.text = @"4 days left";
    rightStatusLabel.font = [ UIFont fontWithName: @"SourceSansPro-Regular" size: 13.0 ];
    rightStatusLabel.textColor = [Utils getDarkerGray];
    [self addSubview:rightStatusLabel];
    // == chart ends
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
