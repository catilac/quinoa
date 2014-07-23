//
//  ActivityCell.h
//  quinoa
//
//  Created by Amie Kweon on 7/12/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
#import "User.h"

@interface ActivityCell : UICollectionViewCell

@property (nonatomic, strong) Activity *activity;
@property BOOL liked;

- (void)setActivity:(Activity *)activity showHeader:(BOOL)showHeader;

- (void)setActivity:(Activity *)activity showHeader:(BOOL)showHeader showLike:(BOOL)showLike;

- (CGSize)cellSize;
@end
