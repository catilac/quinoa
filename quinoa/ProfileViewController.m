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
#import "UILabel+QuinoaLabel.h"

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
        self.title = @"My Profile";
        self.user = [User currentUser];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self getProfile];

    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getProfile {
    [self.user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self updateUI];
    }];
}


- (IBAction)onSaveProfileClick:(id)sender {
    self.user.firstName = self.firstNameTextBox.text;
    self.user.lastName = self.lastNameTextBox.text;
    self.user.birthday = self.birthdayTextBox.text;
    self.user.birthday = (self.genderSegmentControl.selectedSegmentIndex == 0) ? @"F" : @"M";
    self.user.weight = [NSNumber numberWithFloat:[self.weightTextBox.text floatValue]];
    self.user.height = self.heightTextBox.text;
    [self.user saveEventually];
}
- (IBAction)onTap:(id)sender {
    
    [self.view endEditing:YES];
}

- (void)updateUI {
    self.firstNameTextBox.text = self.user.firstName;
    self.lastNameTextBox.text = self.user.lastName;
    self.birthdayTextBox.text = self.user.birthday;
    self.weightTextBox.text = [NSString stringWithFormat:@"%@", self.user.weight];
    self.heightTextBox.text = self.user.height;

    if([self.user.gender isEqual: @"F"])
        self.genderSegmentControl.selectedSegmentIndex = 0;
    else
        self.genderSegmentControl.selectedSegmentIndex = 1;

}
@end
