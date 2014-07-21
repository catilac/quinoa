//
//  DailyActivity.h
//  quinoa
//
//  Created by Hemen Chhatbar on 7/20/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface DailyActivity : NSObject


@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSString *physicalActivityDuration;
@property (strong, nonatomic) PFFile *foodImage;

@end
