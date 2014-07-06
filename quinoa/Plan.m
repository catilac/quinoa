//
//  Plan.m
//  quinoa
//
//  Created by Amie Kweon on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "Plan.h"
#import "PlanAttribute.h"
#import <Parse/PFObject+Subclass.h>

@implementation Plan

@synthesize attributes;

+ (NSString *)parseClassName {
    return @"Plan";
}

+ (void)getPlanByUser:(PFUser *)user
                    success:(void (^) (PFObject *object))success
                      error:(void (^) (NSError *error))error {

    PFQuery *query = [Plan query];
    [query whereKey:@"user" equalTo:user];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *errorFromParse) {

        if (success) {
            success(object);
        }
        if (errorFromParse) {
            error(errorFromParse);
        }
    }];
}

@end
