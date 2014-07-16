//
//  MoreViewController.m
//  quinoa
//
//  Created by Amie Kweon on 7/7/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "MoreViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "UILabel+QuinoaLabel.h"
#import "Utils.h"

//#import "ProfileViewController.h"

@interface MoreViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuItems;

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.menuItems = @[@"My Profile",@"Logout"];
        self.title = @"More";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView reloadData];
    
    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.menuItems[indexPath.row];
    
    UIFont *myFont = [ UIFont fontWithName: @"SourceSansPro-Regular" size: 20.0 ];
    cell.textLabel.font = myFont;
    cell.textLabel.textColor = [Utils getDarkBlue];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *menu = self.menuItems[indexPath.row];
    if ([menu isEqualToString:@"My Profile"]) {
        // TODO: Go to Profile
        // ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
        //[self.navigationController pushViewController:profileViewController animated:YES];
    } else if ([menu isEqualToString:@"Logout"]) {
        [PFUser logOut];
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

- (void)setupUI {
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
@end
