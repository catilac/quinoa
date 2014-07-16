//
//  User.m
//  quinoa
//
//  Created by Amie Kweon on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic username, email, firstName, lastName, role, location;
@dynamic gender, birthday, height, weight;
@dynamic currentTrainer, image;

- (BOOL)isExpert {
    return [self.role isEqualToString:@"expert"];
}

- (NSString *)getDisplayName {
    if (self.firstName) {
        return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    } else {
        return self.email;
    }
}

- (NSString *)getDisplayGender {
    if ([self.gender isEqualToString:@"F"]) {
        return @"Female";
    } else if ([self.gender isEqualToString:@"M"]) {
        return @"Male";
    } else {
        return @"";
    }
}

- (UIImage *)getPlaceholderImage {
    return [UIImage imageNamed:@"avatar"];
}

- (NSString *)getMetaInfo {
    NSString *gender = [self getDisplayGender];
    NSMutableArray *meta = [[NSMutableArray alloc] init];
    if ([gender length] > 0) {
        [meta addObject:gender];
    }
    if ([self.location length] > 0) {
        [meta addObject:self.location];
    }
    return [meta componentsJoinedByString:@" • "];
}

+ (User *)currentUser {
    return (User *)[PFUser currentUser];
}

@end
