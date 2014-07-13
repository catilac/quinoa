//
//  ExpertDetailViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ExpertDetailViewController.h"
#import "ChatViewController.h"
#import "ExpertBrowserViewController.h"

@interface ExpertDetailViewController ()

@property (strong, nonatomic) PFUser *expert;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UITableView *reviewsTableView;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *selectExpertButton;

@end

@implementation ExpertDetailViewController

- (id)initWithExpert:(PFUser *)expert {
    self = [super init];
    if (self) {
        [self setExpert:expert];
    }
    return self;
}

- (id)initWithExpert:(PFUser *)expert modal:(Boolean)isModal {
    self = [super init];
    if (self) {
        [self setExpert:expert];
        self.isModal = isModal;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"My Trainer";
        
        if (!self.isModal) {
            UIBarButtonItem *browse = [[UIBarButtonItem alloc] initWithTitle:@"Browse"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(showExpertsBrowser)];
            self.navigationItem.rightBarButtonItem = browse;
        }
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameLabel.text = self.expert.email;
    
    // Style elements on profile
    self.profileImage.layer.cornerRadius= 53;
    self.chatButton.layer.cornerRadius= 3;
    self.selectExpertButton.layer.cornerRadius= 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onChat:(id)sender {
    ChatViewController *chatView = [[ChatViewController alloc] initWithUser:self.expert];
    [self.navigationController pushViewController:chatView animated:YES];
}

- (void)showExpertsBrowser {
    if (self.isModal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        ExpertBrowserViewController *expertBrowser = [[ExpertBrowserViewController alloc] initIsModal:YES];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:expertBrowser];
        [self presentViewController:nc animated:YES completion:^{
            NSLog(@"Presenting Expert Browser");
        }];
    }
}

@end
