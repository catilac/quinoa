//
//  LoginViewController.h
//  quinoa
//
//  Created by Hemen Chhatbar on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"

@interface LoginViewController : UIViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end
