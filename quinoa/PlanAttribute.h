//
//  PlanAttribute.h
//  quinoa
//
//  Created by Amie Kweon on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Plan.h"

@interface PlanAttribute : PFObject<PFSubclassing>

@property (retain) NSString *planText;

+ (NSString *)parseClassName;

+ (void)getPlanAttributesByPlan:(Plan *)plan
               success:(void (^) (NSArray *objects))success
                 error:(void (^) (NSError *error))error;

@end