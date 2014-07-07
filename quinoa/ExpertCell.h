//
//  ExpertCell.h
//  quinoa
//
//  Created by Chirag Davé on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol ExpertCellDelegate <NSObject>

- (void)showExpertDetail:(PFUser *)expert;

@end

@interface ExpertCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UITableView *reviewsTableView;

@property (strong, nonatomic) PFUser *expert;

@property (weak, nonatomic) UIViewController<ExpertCellDelegate> *delegate;

- (void)setValuesWithExpert:(PFUser *)expert;

@end
