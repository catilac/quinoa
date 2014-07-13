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

+ (void)loadImageFile:(PFFile *)file inImageView:(UIImageView *)imageView withAnimation:(BOOL)enableAnimation {
    __weak UIImageView *iv = imageView;

    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            //[imageView setImage:[UIImage imageWithData:data]];
            iv.image = [UIImage imageWithData:data];
        }
    }];



//    NSURL *urlObject = [NSURL URLWithString:url];
//    __weak UIImageView *iv = imageView;
//
//    [imageView
//     setImageWithURLRequest:[NSURLRequest requestWithURL:urlObject]
//     placeholderImage:nil
//     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//         BOOL isCached = (request == nil);
//         if (!isCached && enableAnimation) {
//             iv.alpha = 0.0;
//             iv.image = image;
//             [UIView animateWithDuration:0.5
//                              animations:^{
//                                  iv.alpha = 1.0;
//                              }];
//         } else {
//             iv.image = image;
//         }
//     }
//     failure:nil];
}
@end
