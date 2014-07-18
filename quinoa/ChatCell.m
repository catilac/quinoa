//
//  ChatCell.m
//  quinoa
//
//  Created by Chirag Davé on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ChatCell.h"
#import "Utils.h"

@interface ChatCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end

@implementation ChatCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
            }
    return self;
}

- (void)updateChatCellWithMessage:(Message *)message {
    self.message = message;
    PFUser *currentUser = [PFUser currentUser];
    
    self.messageLabel.text = message.text;
    
    PFUser *sender = (PFUser *)message.sender;
    self.usernameLabel.text = sender.username;
    
    UIFont *usernameFont = [ UIFont fontWithName: @"SourceSansPro-Semibold" size: 12.0 ];
    self.usernameLabel.font = usernameFont;
    
    self.userImage.layer.cornerRadius = 20.0;
    self.userImage.layer.masksToBounds = YES;
    
    UIFont *msgFont = [ UIFont fontWithName: @"SourceSansPro-Light" size: 16.0 ];
    self.messageLabel.font = msgFont;
    
    if ([message.sender.username isEqualToString:currentUser.username]) {
        self.backgroundColor = [Utils getLightGray];
        self.messageLabel.textColor = [Utils getDarkBlue];
        self.usernameLabel.textColor = [Utils getDarkBlue];
        self.userImage.image = [UIImage imageNamed: @"cat.png"];
        
    } else {
        self.backgroundColor = [Utils getGray];
        self.messageLabel.textColor = [UIColor whiteColor];
        self.usernameLabel.textColor = [Utils getVibrantBlue];
        self.userImage.image = [UIImage imageNamed: @"dog.png"];
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
