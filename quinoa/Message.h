//
//  Message.h
//  quinoa
//
//  Created by Chirag Davé on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Message : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) PFUser *sender;
@property (strong, nonatomic) PFUser *recipient;
@property (strong, nonatomic) NSString *threadId;

+ (NSString *)parseClassName;
+ (NSString *)calcThreadIdWithSender:(PFUser *)sender recipient:(PFUser *)recipient;

+ (Message *)sendMessageToUser:(PFUser *)recipient fromUser:(PFUser *)sender message:(NSString *)message;

@end
