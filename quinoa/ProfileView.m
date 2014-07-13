//
//  ProfileView.m
//  quinoa
//
//  Created by Amie Kweon on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ProfileView.h"

@interface ProfileView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;

@end

@implementation ProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUser:(PFUser *)user {
    _user = user;

    if (user[@"firstName"]) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user[@"firstName"], self.user[@"lastName"]];
    } else {
        self.nameLabel.text = self.user[@"email"];
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
