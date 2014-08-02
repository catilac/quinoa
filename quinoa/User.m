//
//  User.m
//  quinoa
//
//  Created by Amie Kweon on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "User.h"
#import "Activity.h"

@implementation User

@dynamic username, email, firstName, lastName, role, location;
@dynamic gender, birthday;
@dynamic height, weight, currentWeight, averageActivityDuration;
@dynamic currentTrainer, image;
@dynamic newMessageCount, newActivityCount;
@dynamic lastActiveAt;

- (BOOL)isExpert {
    return [self.role isEqualToString:@"expert"];
}

- (NSString *)getDisplayName {
    if (self.firstName && self.lastName) {
        return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    } else if (self.firstName) {
        return [NSString stringWithFormat:@"%@", self.firstName];
    } else {
        return self.email;
    }
}

- (NSString *)getDisplayGender {
    if ([self.gender isEqualToString:@"F"]) {
        return @"Female";
    } else if ([self.gender isEqualToString:@"M"]) {
        return @"Male";
    } else {
        return @"";
    }
}

- (UIImage *)getPlaceholderImage {
    return [UIImage imageNamed:@"avatar"];
}

- (NSString *)getMetaInfo {
    NSString *gender = [self getDisplayGender];
    NSMutableArray *meta = [[NSMutableArray alloc] init];
    if ([gender length] > 0) {
        [meta addObject:gender];
    }
    if ([self.location length] > 0) {
        [meta addObject:self.location];
    }
    return [meta componentsJoinedByString:@" • "];
}

- (NSString *)getSexAndAge {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (self.gender) {
        [array addObject:self.gender];
    }
    
    if (self.birthday) {
        NSDate *today = [NSDate date];
        NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                           components:NSYearCalendarUnit
                                           fromDate:self.birthday
                                           toDate:today
                                           options:0];
        
        [array addObject:[NSString stringWithFormat:@"%ld years old", (long)ageComponents.year]];
    }

    return [array componentsJoinedByString:@" • "];
}

- (NSNumber *)getWeightDifference {
    NSNumber *difference = [NSNumber numberWithFloat:([self.currentWeight floatValue] - [self.weight floatValue])];
    return difference;
}

- (NSString *)hhmmFormatAvgActivityDuration {
    NSDateComponents* c = [[NSDateComponents alloc] init];
    [c setSecond:[self.averageActivityDuration floatValue]];
    
    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate* d = [cal dateFromComponents:c];
    
    NSDateComponents* result = [cal components:NSHourCalendarUnit |
                                NSMinuteCalendarUnit |
                                NSSecondCalendarUnit
                                      fromDate:d];
    
    return [NSString stringWithFormat:@"%0ldh %0ldm", [result hour], (long)[result minute]];
}

// I don't know how to override a setter for dynamic property..
// create an instance method that updates self.currentWeight and remote data
- (void)updateCurrentWeight:(NSNumber *)currentWeight {
    self.currentWeight = currentWeight;
    [self saveInBackground];
}

- (void)updateAverageActivityDuration {
    [Activity getAverageByUser:self byActivity:ActivityTypePhysical success:^(NSNumber *average) {
        self.averageActivityDuration = average;
        [self saveInBackground];
    } error:^(NSError *error) {
        NSLog(@"User.updateAverageActivityDuration error: %@", error.description);
    }];
}

- (void)updateLastActiveAt {
    self.lastActiveAt = [NSDate date];
    [self saveInBackground];
}

- (void)updateNewMessageCount {
//    if (self.newMessageCount == nil) {
//        self.newMessageCount = 0;
//    }
    double plusOne = [self.newMessageCount doubleValue] + 1;
    self.newMessageCount = [NSNumber numberWithDouble:plusOne];
    [self saveInBackground];
}

- (void)resetNewMessageCount {
    self.newMessageCount = 0;
    [self saveInBackground];
}

- (void)selectExpert:(User *)expert {
    self.currentTrainer = expert;
    [self saveInBackground];
}

- (NSNumber *)getUserWeight {
    NSNumber *weight;
    if (self.currentWeight) {
        weight = self.currentWeight;
    } else if (self.weight) {
        weight = self.weight;
    } else {
        weight = [NSNumber numberWithInt:150]; // Prevent showing 0 weight
    }
    return weight;
}

+ (User *)currentUser {
    return (User *)[PFUser currentUser];
}

@end
