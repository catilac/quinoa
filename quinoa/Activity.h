//
//  Activity.h
//  quinoa
//
//  Created by Amie Kweon on 7/12/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"

typedef enum {
    Eating,
    Weight,
    Physical
} ActivityType;

@interface Activity : PFObject<PFSubclassing>

@property (assign) ActivityType activityType;
@property (strong, nonatomic) NSString *activityUnit;
@property (strong, nonatomic) NSNumber *activityValue;
@property (strong, nonatomic) PFFile *image;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) User *user;


+ (NSString *)parseClassName;
+ (Activity *)trackEating:(PFFile *)image description:(NSString *)description;
+ (Activity *)trackPhysical:(NSNumber *)duration;
+ (Activity *)trackWeight:(NSNumber *)weight;

+ (void)getActivitiesByUser:(User *)user
                    success:(void (^) (NSArray *objects))success
                      error:(void (^) (NSError *error))error;

+ (void)getClientActivitiesByExpert:(User *)expert
                    success:(void (^) (NSArray *objects))success
                      error:(void (^) (NSError *error))error;

+ (void)getAverageByUser:(User *)user
              byActivity:(ActivityType)activityType
                 success:(void (^) (NSNumber *average))success
                   error:(void (^) (NSError *error))error;

+ (void)likeActivityById:(NSString *)activityId
              byExpertId:(NSString *)expertId;

+ (void)unlikeActivityById:(NSString *)activityId
              byExpertId:(NSString *)expertId;

@end
