//
//  ProfileView.h
//  quinoa
//
//  Created by Amie Kweon on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"
#import "Utils.h"

@interface ProfileView : UIView

@property (strong, nonatomic) User *user;

@end
