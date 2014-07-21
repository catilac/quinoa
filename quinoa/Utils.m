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

+ (UIColor *)getVibrantBlue {
    return [UIColor colorWithRed:0.278 green:0.651 blue:0.839 alpha:1];
}

+ (UIColor *)getGreen {
    return [UIColor colorWithRed:0.263 green:0.800 blue:0.522 alpha:1];
}

+ (UIColor *)getGray {
    return [UIColor colorWithRed:0.780 green:0.816 blue:0.851 alpha:1];
}

+ (UIColor *)getLightGray {
    return [UIColor colorWithRed:0.949 green:0.961 blue:0.969 alpha:1];
}

+ (UIColor *)getRed {
    return [UIColor colorWithRed:0.890 green:0.302 blue:0.380 alpha:1];
}

+ (void)loadImageFile:(PFFile *)file inImageView:(UIImageView *)imageView withAnimation:(BOOL)enableAnimation {
    __weak UIImageView *iv = imageView;

    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            iv.image = [UIImage imageWithData:data];
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

+ (NSString *)getFriendlyTime:(NSNumber *)seconds {
    NSString *result = @"";
    float minutes = [seconds floatValue] / 60;
    if (minutes >= 60) {
        float hours = (minutes / 60);
        result = [NSString stringWithFormat:@"%0.0f %@", hours, ((hours < 2) ? @"Hour" : @"Hours")];
    } else {
        result = [NSString stringWithFormat:@"%0.0f %@", minutes, ((minutes < 2) ? @"Minute" : @"Minutes")];
    }
    return result;
}

+ (BOOL) sameObjects:(PFObject *)object0 object:(PFObject *)object1 {
    if (object0 == nil || object1 == nil) {
        return NO;
    }
    return [object0 class] == [object1 class] && [object0.objectId isEqualToString:object1.objectId];
}
@end
