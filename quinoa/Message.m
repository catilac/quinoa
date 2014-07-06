//
//  Message.m
//  quinoa
//
//  Created by Chirag Davé on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "Message.h"
#import <Parse/PFObject+Subclass.h>

@implementation Message

@dynamic text;
@dynamic sender;
@dynamic recipient;

+ (NSString *)parseClassName {
    return @"Message";
}

+ (Message *)sendMessageToUser:(PFUser *)recipient fromUser:(PFUser *)sender message:(NSString *)message {
    Message *newMessage = [Message object];
    newMessage.text = message;
    newMessage.sender = sender;
    newMessage.recipient = recipient;
    [newMessage saveInBackground];
    return newMessage;
}

@end
