//
//  PlanActivity.h
//  quinoa
//
//  Created by Amie Kweon on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PlanActivity : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *attributeId;
@property NSDate *date;

+ (NSString *)parseClassName;

+ (void)addActivityByAttributeId:(NSString *)attributeId date:(NSDate *)date;
+ (void)removeActivityByAttributeId:(NSString *)attributeId date:(NSDate *)date;
+ (void)getActivitiesByDate:(NSDate *)date
                    success:(void (^) (NSArray *objects))success
                      error:(void (^) (NSError *error))error;

+ (void)getActivitiesByDateRangeFrom:(NSDate *)startDate
                                  to:(NSDate *)endDate
                             success:(void (^) (NSArray *objects))success
                               error:(void (^) (NSError *error))error;
@end
