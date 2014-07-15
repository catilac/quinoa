//
//  ClientCell.h
//  quinoa
//
//  Created by Chirag Davé on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"

@interface ClientCell : UICollectionViewCell

- (void)setValuesWithClient:(User *)client;

@end
