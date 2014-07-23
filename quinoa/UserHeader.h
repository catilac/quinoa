//
//  UserHeader.h
//  quinoa
//
//  Created by Amie Kweon on 7/14/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
#import "User.h"

@interface UserHeader : UIView

// Required
@property (nonatomic, strong) User *user;

// Optional for the kudos button
@property (nonatomic, strong) Activity *activity;

@property BOOL liked;

@property BOOL showLike;

@end
