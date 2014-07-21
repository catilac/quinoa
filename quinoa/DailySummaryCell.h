//
//  DailySummaryCell.h
//  quinoa
//
//  Created by Hemen Chhatbar on 7/19/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface DailySummaryCell : UICollectionViewCell

@property (nonatomic, strong) Activity *weightActivity;
@property (nonatomic, strong) Activity *physicalActivity;
@property (nonatomic, strong) Activity *foodActivityActivity;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSDictionary *dictionary;

- (void)setActivity:(NSDictionary *)dictionary;

@end
