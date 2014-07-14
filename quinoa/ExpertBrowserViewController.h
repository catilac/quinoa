//
//  ExpertBrowserViewController.h
//  quinoa
//
//  Created by Chirag Davé on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertCell.h"
#import "User.h"

@interface ExpertBrowserViewController : UIViewController <UICollectionViewDataSource, ExpertCellDelegate>

@property (nonatomic, assign) Boolean isModal;

- (id)initIsModal:(Boolean)isModal;

@end
