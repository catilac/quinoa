//
//  UserHeader.h
//  quinoa
//
//  Created by Amie Kweon on 7/14/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserHeader : UIView

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *activityId;
@end
