//
//  PlanActivity.m
//  quinoa
//
//  Created by Amie Kweon on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "PlanActivity.h"
#import <Parse/PFObject+Subclass.h>

@implementation PlanActivity

@dynamic date, attributeId;

+ (NSString *)parseClassName {
    return @"PlanActivity";
}

+ (void)addActivityByAttributeId:(NSString *)attributeId date:(NSDate *)date {
    PlanActivity *activity = [PlanActivity object];
    activity.attributeId = attributeId;
    activity.date = date;

    [activity saveInBackground];
}
+ (void)removeActivityByAttributeId:(NSString *)attributeId date:(NSDate *)date {
    PFQuery *query = [PFQuery queryWithClassName:@"PlanActivity"];
    [query whereKey:@"attributeId" equalTo:attributeId];
    [query whereKey:@"date" equalTo:date];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            [object deleteInBackground];
        }
    }];
}
+ (void)getActivitiesByDate:(NSDate *)date
                    success:(void (^) (NSArray *objects))success
                      error:(void (^) (NSError *error))error {
    PFQuery *query = [PFQuery queryWithClassName:@"PlanActivity"];
    [query whereKey:@"date" equalTo:date];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *errorFromParse) {
        if (success) {
            success(activities);
        }
        if (errorFromParse) {
            error(errorFromParse);
        }
    }];
}
@end
