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
+ (UIColor *)getDarkerBlue;
+ (UIColor *)getShadowBlue;
+ (UIColor *)getDarkestBlue;
+ (UIColor *)getVibrantBlue;
+ (UIColor *)getGreen;
+ (UIColor *)getGreenClear;
+ (UIColor *)getGray;
+ (UIColor *)getGrayBorder;
+ (UIColor *)getDarkerGray;
+ (UIColor *)getLightGray;
+ (UIColor *)getRed;
+ (UIColor *)getOrange;
+ (UIColor *)getWhite;

+ (void)loadImageFile:(PFFile *)file inImageView:(UIImageView *)imageView withAnimation:(BOOL)enableAnimation;

+ (void)loadImageFile:(PFFile *)file inImageView:(UIImageView *)imageView callback:(void (^)())callback;

+ (void)removeSubviewsFrom:(UIView *)view;

+ (UIImage *)screenshot;

+ (NSString *)getPounds:(NSNumber *)weight;

+ (NSString *)getFriendlyTime:(NSNumber *)seconds;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (BOOL) sameObjects:(PFObject *)object0 object:(PFObject *)object1;

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

+ (NSArray *)getDateRange:(NSDate *)date;

+ (NSArray *)getDateRangeFrom:(NSDate *)startDate to:(NSDate *)endDate;
@end
