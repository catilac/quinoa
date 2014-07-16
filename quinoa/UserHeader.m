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
@interface UserHeader ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *metaLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

// TODO: set this correctly initially
@property BOOL liked;

@end

@implementation UserHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"UserHeader" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        [self addSubview:objects[0]];

        [self.likeButton addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;
    if (user.image) {
        [Utils loadImageFile:self.user.image inImageView:self.imageView withAnimation:YES];
    } else {
        [self.imageView setImage:[UIImage imageNamed:@"avatar"]];
    }
    // Not sure why this is not working :(
    self.imageView.layer.cornerRadius = 30;
    self.nameLabel.text = [user getDisplayName];
    self.metaLabel.text = [user getMetaInfo];

}

- (void)onLike:(id)sender {
    NSLog(@"liked!");
    if (self.liked) {
        [Activity unlikeActivityById:self.activityId byExpertId:self.user.objectId];
    } else {
        [Activity likeActivityById:self.activityId byExpertId:self.user.objectId];
    }
}
@end
