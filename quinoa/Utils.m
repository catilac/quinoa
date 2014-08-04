//
//  Utils.m
//  quinoa
//
//  Created by Amie Kweon on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)getSimpleStringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

//
// Quinoa colors:
// https://github.com/chiragrules/quinoa/wiki/Colors
//
+ (UIColor *)getDarkBlue {
    return [UIColor colorWithRed:0.267 green:0.341 blue:0.412 alpha:1];
}

// FIXME: needs to be the divider/bar chart shade in
// https://files.slack.com/files-pri/T02BRGK5C-F02EDHBH5/trainer-user-profile.png

+ (UIColor *)getShadowBlue {
    return [UIColor colorWithRed:0.227 green:0.306 blue:0.380 alpha:1];
}

+ (UIColor *)getDarkerBlue {
    return [UIColor colorWithRed:67/255.0f green:81/255.0f blue:94/255.0f alpha:1.0f]; /*#43515e*/
}

+ (UIColor *)getDarkestBlue {
    return [UIColor colorWithRed:60/255.0f green:71/255.0f blue:82/255.0f alpha:1.0f]; /*#3c4752*/
}

+ (UIColor *)getVibrantBlue {
    return [UIColor colorWithRed:0.278 green:0.651 blue:0.839 alpha:1];
}

+ (UIColor *)getGreen {
    return [UIColor colorWithRed:0.263 green:0.800 blue:0.522 alpha:1];
}

+ (UIColor *)getGreenClear {
    return [UIColor colorWithRed:0.263 green:0.800 blue:0.522 alpha:0.85];
}

+ (UIColor *)getGray {
    return [UIColor colorWithRed:0.780 green:0.816 blue:0.851 alpha:1];
}

+ (UIColor *)getGrayBorder {
    return [UIColor colorWithRed:0.835 green:0.871 blue:0.890 alpha:1];
}


+ (UIColor *)getDarkerGray {
    return [UIColor colorWithRed:0.576 green:0.663 blue:0.741 alpha:1];
}

+ (UIColor *)getLightGray {
    return [UIColor colorWithRed:0.949 green:0.961 blue:0.969 alpha:1];
}

+ (UIColor *)getRed {
    return [UIColor colorWithRed:0.890 green:0.302 blue:0.380 alpha:1];
}

+ (UIColor *)getOrange {
    return [UIColor colorWithRed:1.000 green:0.580 blue:0.259 alpha:1];
}

+ (UIColor *)getWhite {
    return [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1];
}


+ (void)loadImageFile:(PFFile *)file inImageView:(UIImageView *)imageView withAnimation:(BOOL)enableAnimation {
    __weak UIImageView *iv = imageView;

    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            iv.image = [UIImage imageWithData:data];
        }
    }];
}

+ (void)loadImageFile:(PFFile *)file inImageView:(UIImageView *)imageView callback:(void (^)())callback {
    __weak UIImageView *iv = imageView;

    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            iv.image = [UIImage imageWithData:data];
            if (callback) {
                callback();
            }
        }
    }];
}

+ (void)removeSubviewsFrom:(UIView *)view {
    NSArray *subviews = [view subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
}

+ (UIImage *)screenshot {
    CGSize imageSize = CGSizeZero;

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (NSString *)getPounds:(NSNumber *)weight {
    if ([weight doubleValue] > 1) {
        return [NSString stringWithFormat:@"%d pounds", [weight intValue]];
    } else {
        return [NSString stringWithFormat:@"%d pound", [weight intValue]];
    }
}

// I'm messy, but I work!
// Based on # of seconds, return friendly time string such as
// "x Minutes" or "x Hours y minutes"
+ (NSString *)getFriendlyTime:(NSNumber *)seconds {
    NSString *result = @"";
    float secondsFloat = round([seconds doubleValue]);
    float minutes = round(secondsFloat / 60);
    if (minutes >= 60) {
        int hours = round(minutes / 60);
        result = [NSString stringWithFormat:@"%d %@", hours, ((hours < 2) ? @"h" : @"h")];
        float remainingMinutes = floorf((minutes - (hours * 60)) * 100) / 100;
        if (remainingMinutes > 0) {
            NSString *minutesInString = [NSString stringWithFormat:@" %0.0f %@", remainingMinutes, ((remainingMinutes < 2) ? @"m" : @"m")];
            result = [result stringByAppendingString:minutesInString];
        }
    } else {
        result = [NSString stringWithFormat:@"%0.0f %@", minutes, ((minutes < 2) ? @"m" : @"m")];
    }
    return result;
}

+ (BOOL) sameObjects:(PFObject *)object0 object:(PFObject *)object1 {
    if (object0 == nil || object1 == nil) {
        return NO;
    }
    return [object0 class] == [object1 class] && [object0.objectId isEqualToString:object1.objectId];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    NSDate *fromDate;
    NSDate *toDate;

    NSCalendar *calendar = [NSCalendar currentCalendar];

    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];

    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];

    return [difference day];
}

+ (NSArray *)getDateRange:(NSDate *)date {
    NSMutableArray *range = [NSMutableArray arrayWithCapacity:2];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *start = [calendar components:unitFlags fromDate:date];
    start.hour   = 0;
    start.minute = 0;
    start.second = 0;
    NSDate *startDate = [calendar dateFromComponents:start];

    NSDateComponents *end = [calendar components:unitFlags fromDate:date];
    end.hour   = 23;
    end.minute = 59;
    end.second = 59;
    NSDate *endDate = [calendar dateFromComponents:end];

    range[0] = startDate;
    range[1] = endDate;
    return range;
}

+ (NSArray *)getDateRangeFrom:(NSDate *)startDate to:(NSDate *)endDate {
    NSMutableArray *range = [NSMutableArray arrayWithCapacity:2];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *start = [calendar components:unitFlags fromDate:startDate];
    start.hour   = 0;
    start.minute = 0;
    start.second = 0;
    NSDate *rangeStart = [calendar dateFromComponents:start];

    NSDateComponents *end = [calendar components:unitFlags fromDate:endDate];
    end.hour   = 23;
    end.minute = 59;
    end.second = 59;
    NSDate *rangeEnd = [calendar dateFromComponents:end];

    range[0] = rangeStart;
    range[1] = rangeEnd;
    return range;
}
@end
