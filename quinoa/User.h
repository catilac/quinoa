//
//  User.h
//  quinoa
//
//  Created by Amie Kweon on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *role;

@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSNumber *weight;

@property (nonatomic, strong) User *currentTrainer;

- (NSString *)getDisplayName;

+ (User *)currentUser;
@end
