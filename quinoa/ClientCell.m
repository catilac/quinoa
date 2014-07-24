//
//  ClientCell.m
//  quinoa
//
//  Created by Chirag Davé on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ClientCell.h"
#import "UILabel+QuinoaLabel.h"
#import "Utils.h"

@interface ClientCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *clientName;
@property (weak, nonatomic) IBOutlet UILabel *clientBasicInfo;

@property (strong, nonatomic) User *client;

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

- (void)setValuesWithClient:(User *)client {
    
    [self setBackgroundColor:[Utils getLightGray]];
    self.layer.borderColor = [[UIColor colorWithRed:0.780 green:0.816 blue:0.851 alpha:1] CGColor];
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
    
    self.clientName.text = client.username;
    [self.clientName setTextColor:[Utils getDarkBlue]];
    self.clientName.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:[self.clientName.font pointSize]];
    
    self.clientBasicInfo.text = [client getSexAndAge];
    [self.clientBasicInfo setTextColor:[Utils getDarkerGray]];
    self.clientBasicInfo.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:[self.clientBasicInfo.font pointSize]];
    
    if (client.image) {
        [Utils loadImageFile:client.image inImageView:self.profileImage withAnimation:NO];
    } else {
        [self.profileImage setImage:[client getPlaceholderImage]];
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
