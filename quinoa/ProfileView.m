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
        UINib *nib = [UINib nibWithNibName:@"ProfileView" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        [self addSubview:objects[0]];
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;

    self.nameLabel.text = [user getDisplayName];
    if (user.image) {
        [Utils loadImageFile:user.image inImageView:self.imageView withAnimation:NO];
    } else {
        [self.imageView setImage:[user getPlaceholderImage]];
    }
    self.secondaryLabel.text = [user getMetaInfo];
    self.secondaryLabel.textColor = [Utils getVibrantBlue];

    // Styling
    self.imageView.layer.cornerRadius = 53;
    [self.subviews[0] setBackgroundColor:[Utils getDarkBlue]];
}

@end
