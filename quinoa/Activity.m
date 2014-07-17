//
//  Activity.m
//  quinoa
//
//  Created by Amie Kweon on 7/12/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "Activity.h"
#import "User.h"
#import <Parse/PFObject+Subclass.h>

@implementation Activity

@dynamic activityUnit;
@dynamic activityValue;
@dynamic activityType;
@dynamic image;
@dynamic descriptionText;
@dynamic user;

+ (NSString *)parseClassName {
    return @"Activity";
}

+ (Activity *)trackEating:(PFFile *)image description:(NSString *)description{
    Activity *activity = [Activity object];
    activity.user = [User currentUser];
    activity.activityType = Eating;
    activity.image = image;
    activity.descriptionText = description;
    [activity saveInBackground];

    return activity;
}

+ (Activity *)trackPhysical:(NSNumber *)duration {
    Activity *activity = [Activity object];
    activity.user = [User currentUser];
    activity.activityType = Physical;
    activity.activityValue = duration;
    activity.activityUnit = @"min";
    activity.descriptionText = @"Physical Activity";
    [activity saveInBackground];
    
    return activity;
}

+ (Activity *)trackWeight:(NSNumber *)weight {
    Activity *activity = [Activity object];
    activity.user = [User currentUser];
    activity.activityType = Weight;
    activity.activityValue = weight;
    activity.activityUnit = @"lbs";
    activity.descriptionText = @"Weight";
    [activity saveInBackground];
    
    return activity;
}


+ (void)getActivitiesByUser:(User *)user
              success:(void (^) (NSArray *objects))success
                error:(void (^) (NSError *error))error {

    PFQuery *query = [Activity query];
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:@"user" equalTo:user];
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *errorFromParse) {

        if (success) {
            success(objects);
        }
        if (errorFromParse) {
            error(errorFromParse);
        }
    }];
}

+ (void)getClientActivitiesByExpert:(User *)expert
                            success:(void (^) (NSArray *objects))success
                              error:(void (^) (NSError *error))error {
    PFQuery *clientQuery = [User query];
    [clientQuery whereKey:@"currentTrainer" equalTo:expert];
    [clientQuery findObjectsInBackgroundWithBlock:^(NSArray *clients, NSError *errorFromParse) {
        PFQuery *query = [Activity query];
        [query whereKey:@"user" containedIn:clients];
        [query includeKey:@"user"];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *errorFromParse) {
            if (success) {
                success(objects);
            }
            if (errorFromParse) {
                error(errorFromParse);
            }
        }];
    }];
}

+ (void)getAverageByUser:(User *)user
              byActivity:(ActivityType)activityType
                 success:(void (^) (NSNumber *average))success
                   error:(void (^) (NSError *error))error {
    PFQuery *query = [Activity query];
    [query whereKey:@"user" equalTo:user];
    [query whereKey:@"activityType" equalTo:@(activityType)];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *errorFromParse) {

        float total = 0;
        for (Activity *activity in objects) {
            total += [activity.activityValue floatValue];
        }
        float average = (total / objects.count);
        if (success) {
            success([NSNumber numberWithFloat:average]);
        }
        if (errorFromParse) {
            error(errorFromParse);
        }
    }];
}

+ (void)likeActivityById:(NSString *)activityId
              byExpertId:(NSString *)expertId {
    PFObject *like = [PFObject objectWithClassName:@"ActivityLike"];
    like[@"activityId"] = activityId;
    like[@"expertId"] = expertId;
    [like saveInBackground];
}

+ (void)unlikeActivityById:(NSString *)activityId
                byExpertId:(NSString *)expertId {
    PFQuery *query = [PFQuery queryWithClassName:@"ActivityLike"];
    [query whereKey:@"activityId" equalTo:activityId];
    [query whereKey:@"expertId" equalTo:expertId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [object deleteInBackground];
    }];
}
@end
