//
//  ClientCell.h
//  quinoa
//
//  Created by Chirag Davé on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ClientCell : UICollectionViewCell

- (void)setValuesWithClient:(PFUser *)client;

@end
