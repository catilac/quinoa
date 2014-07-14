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
#import "ExpertDetailViewController.h"
#import "ActivitiesCollectionViewController.h"
#import "ProfileViewController.h"
#import "MoreViewController.h"
#import "FanOutViewController.h"
#import "MyClientsViewController.h"
#import "UILabel+QuinoaLabel.h"

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
    if (![User currentUser]) { // No user logged in
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
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(User *)user {
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
    
    [User logOut];
    [self.navigationController popViewControllerAnimated:YES];
    [self showLoginAndRegistration];
}

- (void)setupNavigation {
    User *currentUser = [User currentUser];
    if ([currentUser[@"role"] isEqualToString:@"expert"]) {
        [self setupNavigationForExpert];
    } else {
        [self setupNavigationForUser];
    }
}

- (void)setupNavigationForExpert {
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    // My Clients Tab
    MyClientsViewController *myClientsViewController = [[MyClientsViewController alloc] init];
    UINavigationController *myClientsNavController = [[UINavigationController alloc] initWithRootViewController:myClientsViewController];

    // More Tab
    MoreViewController *moreViewController = [[MoreViewController alloc] init];
    UINavigationController *moreNavController = [[UINavigationController alloc] initWithRootViewController:moreViewController];
    moreNavController.tabBarItem.title = @"More";
    moreNavController.tabBarItem.image = [UIImage imageNamed:@"clientFeed"];
    
    tabBarController.viewControllers = @[myClientsNavController, moreNavController];


    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:tabBarController];
}

- (void)setupNavigationForUser {
    User *trainer = [[User currentUser] objectForKey:@"currentTrainer"];
    UIViewController *expertViewController;
    if (trainer) {
        expertViewController = [[ExpertDetailViewController alloc] initWithExpert:trainer];
    } else {
        expertViewController = [[ExpertBrowserViewController alloc] init];        
    }
    
    UINavigationController *expertNavController = [[UINavigationController alloc] initWithRootViewController:expertViewController];
    expertNavController.tabBarItem.title = @"My Trainer";
    expertNavController.tabBarItem.image = [[UIImage imageNamed:@"myTrainer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    expertNavController.tabBarItem.selectedImage = [[UIImage imageNamed:@"myTrainer-selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    ActivitiesCollectionViewController *activitiesController = [[ActivitiesCollectionViewController alloc] init];
    UINavigationController *activitiesNavController = [[UINavigationController alloc] initWithRootViewController:activitiesController];
    activitiesNavController.tabBarItem.title = @"My Activity";
    activitiesNavController.tabBarItem.image = [[UIImage imageNamed:@"myActivity"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    activitiesNavController.tabBarItem.selectedImage = [[UIImage imageNamed:@"myActivity-selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    UINavigationController *profileNavController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    profileNavController.tabBarItem.title = @"Profile";
    profileNavController.tabBarItem.image = [[UIImage imageNamed:@"myClients"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    profileNavController.tabBarItem.selectedImage = [[UIImage imageNamed:@"myClients-selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    MoreViewController *moreViewController = [[MoreViewController alloc] init];
    UINavigationController *moreNavController = [[UINavigationController alloc] initWithRootViewController:moreViewController];
    moreNavController.tabBarItem.title = @"More";
    moreNavController.tabBarItem.image = [[UIImage imageNamed:@"clientFeed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    moreNavController.tabBarItem.selectedImage = [[UIImage imageNamed:@"clientFeed-selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    FanOutViewController *fanOutControl = [[FanOutViewController alloc] init];
    UINavigationController *trackingNavController = [[UINavigationController alloc] initWithRootViewController:fanOutControl];

    tabBarController.viewControllers = @[expertNavController, activitiesNavController, trackingNavController, profileNavController, moreNavController];

    // Add custom view for custom track UITabBarItem
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    UIView *trackButton = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width/2-25, screenSize.height-65, 50, 65)];
    [trackButton setUserInteractionEnabled:NO];
    [trackButton setBackgroundColor:[UIColor redColor]];
    [tabBarController.view addSubview:trackButton];

    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:tabBarController];
}
@end
