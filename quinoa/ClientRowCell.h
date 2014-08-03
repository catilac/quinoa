//
//  ClientRowCell.h
//  quinoa
//
//  Created by Amie Kweon on 7/27/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"


@protocol ClientRowCellDelegate <NSObject>

- (void)loadChatView:(User *)user;

@end

@interface ClientRowCell : UICollectionViewCell

@property (strong, nonatomic) User *client;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) id<ClientRowCellDelegate> delegate;

@end
