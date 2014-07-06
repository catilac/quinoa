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

+ (NSString *)parseClassName;

@end
