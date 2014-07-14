//
//  ProfileCell.m
//  quinoa
//
//  Created by Amie Kweon on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ProfileCell.h"
#import "ProfileView.h"

@interface ProfileCell ()
@property (strong, nonatomic) IBOutlet ProfileView *profileView;

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

    //ProfileView *profileView = [[ProfileView alloc] initWithFrame:CGRectMake(0, 0, 320, 230)];
    ProfileView *profileView = [[ProfileView alloc] init];
    profileView.user = self.user;
    [self addSubview:profileView];
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
