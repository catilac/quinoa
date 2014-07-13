//
//  ActivityCell.h
//  quinoa
//
//  Created by Amie Kweon on 7/12/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface ActivityCell : UICollectionViewCell

//@property (nonatomic) ActivityType activityType;
@property (nonatomic, strong) Activity *activity;

//- (id)initWithActivityType:(ActivityType)activityType;

@end
