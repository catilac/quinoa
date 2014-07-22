//
//  QuinoaSignUpViewController.m
//  quinoa
//
//  Created by Amie Kweon on 7/21/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "QuinoaSignUpViewController.h"
#import "Utils.h"

@interface QuinoaSignUpViewController ()

@end

@implementation QuinoaSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Customize logo, color, font, background here.
    // Look at this example for customization:
    // https://github.com/ParsePlatform/LoginAndSignUpTutorial/blob/master/LogInAndSignUpDemo/MySignUpViewController.m#L20

    // [self.signUpView setBackgroundColor:[Utils getDarkBlue]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    // Customize positioning here.
    // https://github.com/ParsePlatform/LoginAndSignUpTutorial/blob/master/LogInAndSignUpDemo/MySignUpViewController.m#L60
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
