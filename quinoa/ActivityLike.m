//
//  ActivityLike.m
//  quinoa
//
//  Created by Chirag Davé on 7/17/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ActivityLike.h"
#import <Parse/PFObject+Subclass.h>

@implementation ActivityLike

@dynamic user;
@dynamic expert;
@dynamic activity;
@dynamic activityType;

+ (NSString *)parseClassName {
    return @"ActivityLike";
}

+ (void)getActivityLikesByUser:(User *)user
                       success:(void (^)(NSArray *activityLikes))success
                         error:(void (^)(NSError *error))error {
    PFQuery *query = [ActivityLike query];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activityLikes, NSError *errorFromParse) {
        if (success) {
            success(activityLikes);
        }
        if (errorFromParse) {
            error(errorFromParse);
        }
    }];
}

+ (void)getActivityLikesByExpert:(User *)expert
                       success:(void (^)(NSArray *activityLikes))success
                         error:(void (^)(NSError *error))error {
    PFQuery *query = [ActivityLike query];
    [query whereKey:@"expert" equalTo:expert];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activityLikes, NSError *errorFromParse) {
        if (success) {
            success(activityLikes);
        }
        if (errorFromParse) {
            error(errorFromParse);
        }
    }];
}

+ (ActivityLike *)likeActivity:(Activity *)activity
                          user:(User *)user
                        expert:(User *)expert {
    ActivityLike *newActivityLike = [ActivityLike object];
    newActivityLike.user = user;
    newActivityLike.expert = expert;
    newActivityLike.activity = activity;
    newActivityLike.activityType = activity.activityType;
    [newActivityLike saveInBackground];

    return newActivityLike;
}

+ (void)unlikeActivity:(Activity *)activity
                  expert:(User *)expert {
    PFQuery *query = [ActivityLike query];
    [query whereKey:@"activity" equalTo:activity];
    [query whereKey:@"expert" equalTo:expert];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [object deleteInBackground];
    }];
}
@end
