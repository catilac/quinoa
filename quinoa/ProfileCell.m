//
//  ProfileCell.m
//  quinoa
//
//  Created by Amie Kweon on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ProfileCell.h"
#import "ProfileViewWithActivity.h"

@interface ProfileCell ()
@property (strong, nonatomic) IBOutlet ProfileViewWithActivity *profileView;

@end

@implementation ProfileCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;

    ProfileViewWithActivity *profileView = [[ProfileViewWithActivity alloc] initWithFrame:self.frame];
       profileView.user = self.user;
    [self addSubview:profileView];
    [profileView layoutSubviews];
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
