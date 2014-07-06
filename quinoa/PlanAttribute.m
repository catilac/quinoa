//
//  PlanAttribute.m
//  quinoa
//
//  Created by Amie Kweon on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "PlanAttribute.h"
#import <Parse/PFObject+Subclass.h>

@implementation PlanAttribute

@dynamic planText;

+ (NSString *)parseClassName {
    return @"PlanAttribute";
}

+ (void)getPlanAttributesByPlan:(Plan *)plan
                        success:(void (^) (NSArray *objects))success
                          error:(void (^) (NSError *error))error {

    PFQuery *query = [PlanAttribute query];
    [query whereKey:@"plan" equalTo:plan];
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
