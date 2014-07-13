//
//  Activity.m
//  quinoa
//
//  Created by Amie Kweon on 7/12/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "Activity.h"
#import <Parse/PFObject+Subclass.h>

@implementation Activity

@dynamic activityUnit;
@dynamic activityValue;
@dynamic activityType;
@dynamic image;
@dynamic description;
@dynamic user;

+ (NSString *)parseClassName {
    return @"Activity";
}

+ (Activity *)trackEating:(PFFile *)image description:(NSString *)description {
    Activity *activity = [Activity object];
    activity.user = [PFUser currentUser];
    activity.activityType = Eating;
    activity.image = image;
    activity.description = description;
    [activity saveInBackground];

    return activity;
}

+ (void)getActivitiesByUser:(PFUser *)user
              success:(void (^) (NSArray *objects))success
                error:(void (^) (NSError *error))error {

    PFQuery *query = [Activity query];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *errorFromParse) {

        if (success) {
            success(objects);
        }
        if (errorFromParse) {
            error(errorFromParse);
        }
    }];
}
@end