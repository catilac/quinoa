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

+ (NSString *)parseClassName;

@property (retain) NSString *activityUnit;
@property (retain) NSNumber *activityValue;
@property (assign) ActivityType *activityType;
@property (retain) PFFile *image;
@property (retain) NSString *description;

@end
