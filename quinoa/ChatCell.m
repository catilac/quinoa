//
//  ChatCell.m
//  quinoa
//
//  Created by Chirag Davé on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ChatCell.h"

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
    
    if ([message.sender.username isEqualToString:currentUser.username]) {
        self.backgroundColor = [UIColor greenColor];
    } else {
        self.backgroundColor = [UIColor blueColor];
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
