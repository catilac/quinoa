//
//  LoginViewController.m
//  quinoa
//
//  Created by Hemen Chhatbar on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

#import "ExpertBrowserViewController.h"
#import "MyPlanViewController.h"

@interface LoginViewController ()

- (IBAction)onLogOutClick:(id)sender;

@end

@implementation LoginViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        [self showLoginAndRegistration];
    } else {
        [self setupNavigation];
    }
    
}

- (void)showLoginAndRegistration
{
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton ;
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
    
}

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    // [self dismissViewControllerAnimated:YES completion:NULL];

    [self setupNavigation];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onLogOutClick:(id)sender {
    
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
    [self showLoginAndRegistration];
}

- (void)setupNavigation {
    ExpertBrowserViewController *expertViewController = [[ExpertBrowserViewController alloc] init];
    UINavigationController *expertNavController = [[UINavigationController alloc] initWithRootViewController:expertViewController];

    MyPlanViewController *myPlanViewController = [[MyPlanViewController alloc] init];
    UINavigationController *myPlanNavController = [[UINavigationController alloc] initWithRootViewController:myPlanViewController];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[expertNavController, myPlanNavController];

    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:tabBarController];
}
@end
