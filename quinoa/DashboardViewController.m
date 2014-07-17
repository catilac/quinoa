//
//  DashboardViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/15/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "DashboardViewController.h"
#import "UserHeader.h"
#import "User.h"


@interface DashboardViewController ()

@property (weak, nonatomic) IBOutlet UITableView *feedTable;
@property (strong, nonatomic) NSArray *likes;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) User *expert;
@property (strong, nonatomic) UserHeader *expertHeader;

@end

@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _user = [User currentUser];
        _expert = _user.currentTrainer;
        [_expert fetch];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.feedTable.dataSource = self;
    self.feedTable.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.likes count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark UITableViewDelegate methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.expertHeader = [[UserHeader alloc] init];
    [self.expertHeader setUser:self.expert];
    return self.expertHeader;
}

@end
