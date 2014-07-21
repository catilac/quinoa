//
//  Utils.h
//  quinoa
//
//  Created by Amie Kweon on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Utils : NSObject

+ (NSString *)getSimpleStringFromDate:(NSDate *)date;

+ (UIColor *)getDarkBlue;
+ (UIColor *)getVibrantBlue;
+ (UIColor *)getGreen;
+ (UIColor *)getGray;
+ (UIColor *)getLightGray;
+ (UIColor *)getRed;

+ (void)loadImageFile:(PFFile *)file inImageView:(UIImageView *)imageView withAnimation:(BOOL)enableAnimation;

+ (void)removeSubviewsFrom:(UIView *)view;

+ (UIImage *)screenshot;

+ (NSString *)getPounds:(NSNumber *)weight;

+ (NSString *)getFriendlyTime:(NSNumber *)seconds;

+ (BOOL) sameObjects:(PFObject *)object0 object:(PFObject *)object1;

@end
