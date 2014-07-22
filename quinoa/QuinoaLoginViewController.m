//
//  QuinoaLoginViewController.m
//  quinoa
//
//  Created by Amie Kweon on 7/21/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "QuinoaLoginViewController.h"
#import "Utils.h"

@interface QuinoaLoginViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;

- (void)willShowKeyboard:(NSNotification *)notification;
- (void)willHideKeyboard:(NSNotification *)notification;


@end

@implementation QuinoaLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Customize logo, color, font, background here.
    // Look at this example for customization:
    // https://github.com/ParsePlatform/LoginAndSignUpTutorial/blob/master/LogInAndSignUpDemo/MyLogInViewController.m#L20

    // Background color and logo
    [self.logInView setBackgroundColor:[Utils getDarkBlue]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3eesho-logo.png"]]];
    
    // Add login field background
    self.fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-background.png"]];
    [self.logInView addSubview:self.fieldsBackground];
    [self.logInView sendSubviewToBack:self.fieldsBackground];
    
    // Hide elements on page
    [self.logInView.facebookButton setHidden:YES];
    [self.logInView.externalLogInLabel setText:@""];
    [self.logInView.signUpLabel setText:@""];
    
    // Username Field Styling
    [self.logInView.usernameField.layer setShadowOpacity:0.0f];
    [self.logInView.usernameField setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    [self.logInView.usernameField setTextAlignment:NSTextAlignmentLeft];
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1]];
    
    // Password Field Styling
    [self.logInView.passwordField.layer setShadowOpacity:0.0f];
    [self.logInView.passwordField setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    [self.logInView.passwordField setTextAlignment:NSTextAlignmentLeft];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1]];
    
    // Sign Up Button
    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.logInView.signUpButton.titleLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    [self.logInView.signUpButton setTitleShadowColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:0] forState:UIControlStateNormal];

    //Login Button Styling
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"login-button.png"] forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"login-button-selected.png"] forState:UIControlStateHighlighted];
    [self.logInView.logInButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.logInButton setTitle:@"" forState:UIControlStateHighlighted];
    [self.logInView.logInButton.titleLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
    

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    // Reposition elements here
    // https://github.com/ParsePlatform/LoginAndSignUpTutorial/blob/master/LogInAndSignUpDemo/MyLogInViewController.m#L66
    
    [self.fieldsBackground setFrame:CGRectMake(20, 208, 280, 110)];
    [self.logInView.logInButton setFrame:CGRectMake(20, 340, 280, 50)];
    [self.logInView.logo setFrame:CGRectMake(87, 130, 146, 35)];
    [self.logInView.signUpButton setFrame:CGRectMake(126, 426, 60, 20)];
    [self.logInView.usernameField setFrame:CGRectMake(40, 209, 480, 55)];
    [self.logInView.passwordField setFrame:CGRectMake(40, 259, 480, 55)];
    
    // Kill Login Button Shadow
    [self.logInView.logInButton setTitleShadowColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:0] forState:UIControlStateNormal];
    [self.logInView.logInButton setTitleShadowColor:[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:0] forState:UIControlStateHighlighted];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willShowKeyboard:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the keyboard height and width from the notification
    // Size varies depending on OS, language, orientation
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.logInView.frame = CGRectMake(0, -62, self.logInView.frame.size.width, self.logInView.frame.size.height);
                     }
                     completion:nil];
    
}

- (void)willHideKeyboard:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.logInView.frame = CGRectMake(0, 0, self.logInView.frame.size.width, self.logInView.frame.size.height);
                     }
                     completion:nil];
    
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
