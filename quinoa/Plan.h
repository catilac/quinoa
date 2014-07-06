//
//  Plan.h
//  quinoa
//
//  Created by Amie Kweon on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Plan : PFObject<PFSubclassing>

@property (nonatomic, strong) NSArray *attributes;

+ (NSString *)parseClassName;

+ (void)getPlanByUser:(PFUser *)user
                    success:(void (^) (PFObject *object))success
                      error:(void (^) (NSError *error))error;

@end
