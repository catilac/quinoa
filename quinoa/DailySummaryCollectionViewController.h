//
//  DailySummaryCollectionViewController.h
//  quinoa
//
//  Created by Hemen Chhatbar on 7/19/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"

@interface DailySummaryCollectionViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIView *weeklySummaryView;

@end
