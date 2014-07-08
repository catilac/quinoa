//
//  Profile.m
//  quinoa
//
//  Created by Hemen Chhatbar on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "Profile.h"
#import <Parse/PFObject+Subclass.h>

@implementation Profile


+ (NSString *)parseClassName {
    return @"User";
}

+ (void)getProfile:(PFUser *)user
              success:(void (^) (PFObject *object))success
                error:(void (^) (NSError *error))error {
    
    PFQuery *query = [Profile query];
    [query whereKey:@"objectId" equalTo:user.objectId];
    
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
