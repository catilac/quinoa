//
//  ExpertDetailViewController.h
//  quinoa
//
//  Created by Chirag Davé on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"

@interface ExpertDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) Boolean isModal;

- (id)initWithExpert:(User *)expert;
- (id)initWithExpert:(User *)expert modal:(Boolean)isModal;

@end
