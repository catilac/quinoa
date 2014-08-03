//
//  Goal.m
//  quinoa
//
//  Created by Amie Kweon on 7/30/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "Goal.h"
#import <Parse/PFObject+Subclass.h>
#import "Utils.h"

@implementation Goal

@dynamic user, expert;
@dynamic targetDailyDuration, targetWeight;
@dynamic startAt, endAt;

+ (NSString *)parseClassName {
    return @"Goal";
}

+ (void)getCurrentGoalByUser:(User *)user
                     success:(void (^) (Goal *goal))success
                       error:(void (^) (NSError *error))error {
    PFQuery *query = [Goal query];
    NSDate *today = [NSDate date];
    [query whereKey:@"user" equalTo:user];
    [query whereKey:@"startAt" lessThanOrEqualTo:today];
    [query whereKey:@"endAt" greaterThanOrEqualTo:today];
    [query orderByDescending:@"createdAt"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *errorFromParse) {
        if (success) {
            success((Goal *)object);
        }
        if (errorFromParse) {
            error(errorFromParse);
        }
    }];
}

+ (void)updateGoal:(Goal *)goal
           success:(void (^) (Goal *goal))success
             error:(void (^) (NSError *error))error {
    if (!goal.objectId) {
        goal = [Goal object];
    }
    [goal saveInBackground];
}
@end
