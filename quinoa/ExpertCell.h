//
//  ExpertCell.h
//  quinoa
//
//  Created by Chirag Davé on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"

@protocol ExpertCellDelegate <NSObject>

- (void)selectExpert:(User *)expert;

@end

@interface ExpertCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UITableView *reviewsTableView;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIView *cardBackground;

@property (strong, nonatomic) User *expert;

@property (weak, nonatomic) UIViewController<ExpertCellDelegate> *delegate;

- (void)setValuesWithExpert:(User *)expert;

@end
