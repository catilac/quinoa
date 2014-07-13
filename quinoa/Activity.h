//
//  Activity.h
//  quinoa
//
//  Created by Amie Kweon on 7/12/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

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
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) PFUser *user;


+ (NSString *)parseClassName;
+ (Activity *)trackEating:(PFFile *)image description:(NSString *)description;

@end
