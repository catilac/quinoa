//
//  ProfileViewController.m
//  quinoa
//
//  Created by Hemen Chhatbar on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "Profile.h"
#import <Parse/PFObject+Subclass.h>

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextBox;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextBox;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextBox;
@property (weak, nonatomic) IBOutlet UITextField *weightTextBox;
@property (weak, nonatomic) IBOutlet UITextField *heightTextBox;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentControl;
- (IBAction)onSaveProfileClick:(id)sender;


@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSString *height;
@property (strong, nonatomic) NSString *gender;

@property (nonatomic, strong) Profile *profile;

- (IBAction)onTap:(id)sender;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"My Profile";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getProfile];
    // Do any additional setup after loading the view from its nib.
    
    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getProfile {
    /*[Profile getProfile:[PFUser currentUser] success:^(PFObject *object) {
        
        PFUser *user = (PFUser *)object;
        self.firstNameTextBox.text = [user objectForKey:@"firstName"];
        self.lastNameTextBox.text = [user objectForKey:@"lastName"];
        
        } error:^(NSError *error) {
            NSLog(@"[MyPlan] error: %@", error.description);
        }]; */
    PFUser *loggedInUser = [PFUser currentUser];
    
    
    PFUser *user = [PFQuery getUserObjectWithId:loggedInUser.objectId];
    self.firstNameTextBox.text = [user objectForKey:@"firstName"];
    self.lastNameTextBox.text = [user objectForKey:@"lastName"];
    self.birthdayTextBox.text = [user objectForKey:@"birthday"];
    self.weightTextBox.text = [user objectForKey:@"weight"];
    self.heightTextBox.text = [user objectForKey:@"height"];
    
    if([[user objectForKey:@"gender"]  isEqual: @"F"])
        self.genderSegmentControl.selectedSegmentIndex = 0;
        else
            self.genderSegmentControl.selectedSegmentIndex = 1;
            
    
}


- (IBAction)onSaveProfileClick:(id)sender {
    
    [[PFUser currentUser] setObject:self.firstNameTextBox.text forKey:@"firstName"];
    [[PFUser currentUser] setObject:self.lastNameTextBox.text forKey:@"lastName"];
    [[PFUser currentUser] setObject:self.birthdayTextBox.text forKey:@"birthday"];
    if (self.genderSegmentControl.selectedSegmentIndex == 0)
        [[PFUser currentUser] setObject:@"F" forKey:@"gender"];
    else
        [[PFUser currentUser] setObject:@"M" forKey:@"gender"];
    [[PFUser currentUser] setObject:self.weightTextBox.text forKey:@"weight"];
    [[PFUser currentUser] setObject:self.heightTextBox.text forKey:@"height"];
    
    [[PFUser currentUser] saveEventually];
    
}
- (IBAction)onTap:(id)sender {
    
    [self.view endEditing:YES];
}
@end
