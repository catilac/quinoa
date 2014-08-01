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
@property (weak, nonatomic) IBOutlet UIView *progressView;

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
        [self.divider setBackgroundColor:[Utils getShadowBlue]];
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;

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

    self.progressView.backgroundColor = [Utils getDarkestBlue];
    
    self.chatButton.hidden = !self.isExpertView;
    self.editGoalButton.hidden = !self.isExpertView;

    if (self.isExpertView) {
        self.chatButton.backgroundColor = [Utils getGreen];
        self.chatButton.layer.cornerRadius = 4.0;
        self.chatButton.layer.borderWidth = 2.0;
        self.chatButton.layer.borderColor = [Utils getShadowBlue].CGColor;
        self.chatButton.tintColor = [UIColor whiteColor];

        if (user.newMessageCount) {
            BTBadgeView *badgeView = [[BTBadgeView alloc] initWithFrame:CGRectMake(276, -6, 40, 40)];
            badgeView.shadow = NO;
            badgeView.shine = NO;
            badgeView.fillColor = [Utils getRed];
            badgeView.strokeColor = [Utils getRed];
            badgeView.font = [UIFont fontWithName:@"Helvetica" size:16];
            badgeView.value = [NSString stringWithFormat:@"%@", user.newMessageCount];
            [self addSubview:badgeView];
        }
    }

    self.physicalActivityLabel.textColor = [Utils getDarkerGray];
    self.physicalActivityLabel.font = [ UIFont fontWithName: @"SourceSansPro-Semibold" size: 14.0 ];
    
    self.editGoalButton.tintColor = [Utils getGreen];
    self.editGoalButton.font = [ UIFont fontWithName: @"SourceSansPro-Regular" size: 12.0 ];
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    [self.contentView setBackgroundColor:[Utils getDarkBlue]];

    // This is eventually going to be a custom view chart.
    // == chart starts
    CGFloat percentage = 0.6;
    UIView *chartContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 144, 280, 10)];
    chartContainer.backgroundColor = [Utils getShadowBlue];
    [self addSubview:chartContainer];

    UIView *chartBar = [[UIView alloc] initWithFrame:CGRectMake(20, 144, 280 * percentage, 10)];
    chartBar.backgroundColor = [Utils getVibrantBlue];
    [self addSubview:chartBar];

    UILabel *leftStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 100, 18)];
    leftStatusLabel.text = @"80 mins";
    leftStatusLabel.font = [ UIFont fontWithName: @"Helvetica-Bold" size: 24.0 ];
    leftStatusLabel.textColor = [Utils getVibrantBlue];
    [self addSubview:leftStatusLabel];

    // Need to right align label here
    UILabel *rightStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(198, 126, 100, 18)];
    rightStatusLabel.text = @"240";
    rightStatusLabel.font = [ UIFont fontWithName: @"SourceSansPro-Semibold" size: 12.0 ];
    rightStatusLabel.textAlignment = NSTextAlignmentRight;
    rightStatusLabel.textColor = [Utils getDarkerGray];
    [self addSubview:rightStatusLabel];
    // == chart ends
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
