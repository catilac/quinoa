//
//  ActivityViewController.h
//  quinoa
//
//  Created by Hemen Chhatbar on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImage *image;

- (id)initWithType:(NSString *)activityType;

@end
