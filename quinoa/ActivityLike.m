//
//  ActivityLike.m
//  quinoa
//
//  Created by Chirag Davé on 7/17/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ActivityLike.h"
#import <Parse/PFObject+Subclass.h>

@implementation ActivityLike

@dynamic user;
@dynamic expertId;
@dynamic activity;

+ (NSString *)parseClassName {
    return @"ActivityLike";
}

@end
