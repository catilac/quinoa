//
//  ProfileViewSimple.m
//  quinoa
//
//  Created by Joseph Lee on 7/31/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ProfileViewSimple.h"
#import "Utils.h"

@interface ProfileViewSimple ()

@property (strong, nonatomic) UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *metaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end

@implementation ProfileViewSimple

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UINib *nib = [UINib nibWithNibName:@"ProfileViewSimple" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        self.contentView = objects[0];
        self.contentView.backgroundColor = [Utils getDarkestBlue];
        [self.contentView setFrame:frame];
        [self addSubview:self.contentView];

    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;
    
    self.nameLabel.text = [user getDisplayName];
    self.nameLabel.font = [ UIFont fontWithName: @"SourceSansPro-Semibold" size: 18.0 ];
    self.nameLabel.textColor = [UIColor whiteColor];
    
    self.metaLabel.text = [user getMetaInfo];
    self.metaLabel.font = [ UIFont fontWithName: @"SourceSansPro-Regular" size: 16.0 ];
    self.metaLabel.textColor = [Utils getDarkerGray];
    
    if (user.image) {
        [Utils loadImageFile:user.image inImageView:self.profileImage withAnimation:NO];
    } else {
        [self.profileImage setImage:[user getPlaceholderImage]];
    }
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
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
