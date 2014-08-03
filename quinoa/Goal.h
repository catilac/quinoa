//
//  Goal.h
//  quinoa
//
//  Created by Amie Kweon on 7/30/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"

@interface Goal : PFObject<PFSubclassing>

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) User *expert;
@property (strong, nonatomic) NSNumber *targetDailyDuration;
@property (strong, nonatomic) NSNumber *targetWeight;
@property (strong, nonatomic) NSDate *startAt;
@property (strong, nonatomic) NSDate *endAt;

+ (NSString *)parseClassName;

+ (void)getCurrentGoalByUser:(User *)user
                    success:(void (^) (Goal *goal))success
                      error:(void (^) (NSError *error))error;

+ (void)updateGoal:(Goal *)goal
           success:(void (^) (Goal *goal))success
             error:(void (^) (NSError *error))error;

@end
