//
//  UserHeader.m
//  quinoa
//
//  Created by Amie Kweon on 7/14/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "UserHeader.h"
#import "Utils.h"
#import "Activity.h"
#import "ActivityLike.h"
#import "User.h"

@interface UserHeader ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *metaLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBorder;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (strong, nonatomic) UIView *contentView;

@end

@implementation UserHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"UserHeader" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        self.contentView = objects[0];
        [self.contentView setFrame:frame];
        [self addSubview:self.contentView];

        [self.likeButton setImage:[UIImage imageNamed:@"kudos"] forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"kudos-selected"] forState:UIControlStateSelected];
        [self.likeButton setImage:[UIImage imageNamed:@"kudos-selected"] forState:UIControlStateHighlighted];
        [self.likeButton setImage:[UIImage imageNamed:@"kudos-selected"] forState:UIControlStateSelected | UIControlStateHighlighted];

        [self.likeButton addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;
    if (self.user.image) {
        [Utils loadImageFile:self.user.image inImageView:self.imageView withAnimation:YES];
    } else {
        [self.imageView setImage:[UIImage imageNamed:@"avatar"]];
    }
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    self.nameLabel.text = [self.user getDisplayName];
    if (self.activity != nil) {
        NSDate *now = [NSDate date];
        NSDate *sevenDaysAgo = [now dateByAddingTimeInterval:-7*24*60*60];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        if ([self.activity.updatedAt compare:sevenDaysAgo] == NSOrderedAscending) {
            [dateFormat setDateFormat:@"M-d-YYYY • ha"];
        } else {
            [dateFormat setDateFormat:@"EEEE • ha"];
        }
        self.metaLabel.text = [dateFormat stringFromDate:self.activity.updatedAt];
    } else {
        self.metaLabel.text = [self.user getMetaInfo];
    }
    self.bottomBorder.backgroundColor = [Utils getGray];

    [self.nameLabel setTextColor:[Utils getDarkBlue]];
    [self.metaLabel setTextColor:[Utils getDarkerGray]];

    self.likeButton.hidden = NO;
    [self.likeButton setSelected:self.liked];
}

- (void)onLike:(id)sender {
    if (!self.enableLike) {
        return;
    }
    NSDictionary *likedActivity;
    if (self.liked) {
        likedActivity = @{@"liked": @NO,
                          @"activity": self.activity,
                          @"expert": [User currentUser]};
        
        
        
    } else {
        likedActivity = @{@"liked": @YES,
                          @"activity": self.activity,
                          @"expert": [User currentUser]};
    }
    self.liked = !self.liked;
    [self.likeButton setSelected:self.liked];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"activityLiked"
     object:likedActivity];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.contentView setFrame:self.frame];
}
@end
