//
//  AppDelegate.m
//  quinoa
//
//  Created by Chirag Davé on 7/2/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "ExpertBrowserViewController.h"
#import "Activity.h"
#import "Message.h"
#import "Profile.h"
#import "Activity.h"
#import "User.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Status Bar Style
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    // Navigation bar styling
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.267 green:0.341 blue:0.412 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.263 green:0.800 blue:0.522 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    // Tab Bar Styling
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"SourceSansPro-Semibold" size:11.0f],
                                                        NSForegroundColorAttributeName : [UIColor colorWithRed:0.278 green:0.651 blue:0.839 alpha:1]
                                                        } forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"SourceSansPro-Semibold" size:11.0f],
                                                        NSForegroundColorAttributeName : [UIColor colorWithRed:0.765 green:0.808 blue:0.851 alpha:1]
                                                        } forState:UIControlStateNormal];
    
    // Register sub classes
    [Message registerSubclass];
    [Profile registerSubclass];
    [Activity registerSubclass];
    [User registerSubclass];

    //Parse App Keys
    [Parse setApplicationId:@"Fp5eIufAJJDLCrvaC7ZPBqJmYj5lIQsS2xjLHWQm"
                  clientKey:@"4wviUoVH6lZQWG3n2yGyyncMtKYbuz0RCGG1qen3"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // FaceBook
    [PFFacebookUtils initializeFacebook];
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    self.window.rootViewController = loginViewController;

    // Application wide styles
    //[[UILabel appearance] setFont:[UIFont fontWithName:@"Source Sans Pro"]];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

// Facebook Handlers
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

// Facebook oauth callback
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
