//
//  User.m
//  quinoa
//
//  Created by Amie Kweon on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic username, email, firstName, lastName, role;
@dynamic gender, birthday, height, weight;
@dynamic currentTrainer;

- (NSString *)getDisplayName {
    if (self.firstName) {
        return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    } else {
        return self.email;
    }
}

+ (User *)currentUser {
    return (User *)[PFUser currentUser];
}

@end
