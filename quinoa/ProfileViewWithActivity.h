//
//  ProfileViewWithActivity.h
//  quinoa
//
//  Created by Amie Kweon on 7/27/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol GoalUIDelegate <NSObject>

-(void) showGoalUIClicked;

@end


@interface ProfileViewWithActivity : UIView

@property (strong,nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property BOOL isExpertView;

@property (nonatomic, assign) id<GoalUIDelegate> myDelegate;

@end
