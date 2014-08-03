//
//  ChatCell.m
//  quinoa
//
//  Created by Chirag Davé on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ChatCell.h"
#import "Utils.h"
#import "User.h"

static const CGFloat ContainerWidth = 300;
static const CGFloat MessageWidth = 237;

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
    User *currentUser = [User currentUser];
    
    self.messageLabel.text = message.text;
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.messageLabel.numberOfLines = 0;
    
    User *sender = (User *)message.sender;
    self.usernameLabel.text = sender.username;
    
    UIFont *usernameFont = [ UIFont fontWithName: @"SourceSansPro-Semibold" size: 12.0 ];
    self.usernameLabel.font = usernameFont;
    
    self.userImage.layer.cornerRadius = 20.0;
    self.userImage.layer.masksToBounds = YES;
    
    UIFont *msgFont = [ UIFont fontWithName: @"SourceSansPro-Regular" size: 16.0 ];
    self.messageLabel.font = msgFont;
    
    if ([message.sender.username isEqualToString:currentUser.username]) {
        self.backgroundColor = [Utils getVibrantBlue];
        self.messageLabel.textColor = [UIColor whiteColor];
        self.usernameLabel.textColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [Utils getLightGray];
        self.messageLabel.textColor = [Utils getDarkBlue];
        self.usernameLabel.textColor = [Utils getVibrantBlue];
    }
    
    /*if (sender.image) {
        [Utils loadImageFile:sender.image inImageView:self.userImage withAnimation:NO];
    } else {
        [self.userImage setImage:[sender getPlaceholderImage]];
    }*/
}

- (CGSize)cellSize {
    CGSize size = CGSizeMake(ContainerWidth, 0);

    // Distance from top to MessageLabel
    size.height = 32;
    
    // add height of message label
    NSDictionary *dict = @{NSFontAttributeName: [UIFont fontWithName: @"SourceSansPro-Light" size: 16.0]};
    CGRect rect = [self.message.text
            boundingRectWithSize:CGSizeMake(MessageWidth, 0)
            options:NSStringDrawingUsesLineFragmentOrigin
            attributes:dict
            context:nil];
    size.height += rect.size.height;
    
    // Bottom Margin
    size.height += 5;
    
    return size;
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
