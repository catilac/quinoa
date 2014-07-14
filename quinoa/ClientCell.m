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
    self.backgroundColor = [UIColor colorWithRed:0.949 green:0.961 blue:0.969 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:0.780 green:0.816 blue:0.851 alpha:1] CGColor];
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
    self.clientName.text = client.username;
    self.clientBasicInfo.text = @"Male • 42 years old";
    
    self.profileImage.layer.cornerRadius = 50;

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
