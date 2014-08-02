//
//  User.h
//  quinoa
//
//  Created by Amie Kweon on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) NSNumber *currentWeight;
@property (nonatomic, strong) NSNumber *averageActivityDuration;

@property (nonatomic, strong) User *currentTrainer;
@property (nonatomic, strong) PFFile *image;

// Stats
@property (nonatomic, strong) NSNumber *newMessageCount;
@property (nonatomic, strong) NSNumber *newActivityCount;
@property (nonatomic, strong) NSDate *lastActiveAt;

- (BOOL)isExpert;

- (NSString *)getDisplayName;
- (NSString *)getSexAndAge;

- (NSString *)getDisplayGender;

- (NSString *)getMetaInfo;

- (UIImage *)getPlaceholderImage;

- (NSNumber *)getWeightDifference;

- (NSString *)hhmmFormatAvgActivityDuration;

- (void)updateCurrentWeight:(NSNumber *)updateCurrentWeight;

- (void)updateAverageActivityDuration;

- (void)selectExpert:(User *)expert;

- (void)updateLastActiveAt;

- (void)updateNewMessageCount;

- (void)resetNewMessageCount;

- (NSNumber *)getUserWeight;

+ (User *)currentUser;
@end
