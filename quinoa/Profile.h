//
//  Profile.h
//  quinoa
//
//  Created by Hemen Chhatbar on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Profile : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

+ (void)getProfile:(PFUser *)user
              success:(void (^) (PFObject *object))success
                error:(void (^) (NSError *error))error;


@end
