//
//  ExpertDetailViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ExpertDetailViewController.h"
#import "ChatViewController.h"

@interface ExpertDetailViewController ()

@property (strong, nonatomic) PFUser *expert;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UITableView *reviewsTableView;

@end

@implementation ExpertDetailViewController

- (id)initWithExpert:(PFUser *)expert {
    self = [super init];
    if (self) {
        [self setExpert:expert];
    }
    return self;
}

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
    self.nameLabel.text = self.expert.email;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onChat:(id)sender {
    ChatViewController *chatView = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chatView animated:YES];
}

@end
