//
//  ClientCell.m
//  quinoa
//
//  Created by Chirag Davé on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ClientCell.h"

@interface ClientCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *clientName;
@property (weak, nonatomic) IBOutlet UILabel *clientBasicInfo;

@property (strong, nonatomic) PFUser *client;

@end

@implementation ClientCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setValuesWithClient:(PFUser *)client {
    self.clientName.text = client.username;
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
