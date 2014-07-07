//
//  ExpertDetailViewController.h
//  quinoa
//
//  Created by Chirag Davé on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ExpertDetailViewController : UIViewController

@property (nonatomic, assign) Boolean isModal;

- (id)initWithExpert:(PFUser *)expert;
- (id)initWithExpert:(PFUser *)expert modal:(Boolean)isModal;

@end
