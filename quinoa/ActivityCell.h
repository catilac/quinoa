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
@property (nonatomic, strong) User *user;

- (void)setActivity:(Activity *)activity user:(User *)user;

@end
