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
#import "UILabel+QuinoaLabel.h"
#import "Utils.h"
#import "ActivityLike.h"
#import "ActivityLikeCell.h"

static NSString *LikeCellIdent = @"likeCellIdent";

@interface ExpertDetailViewController ()

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) User *expert;

@property (strong, nonatomic) NSArray *activityLikes;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *selectExpertButton;
@property (weak, nonatomic) IBOutlet UITableView *feedTable;

@property BOOL isMyExpert;
@end

@implementation ExpertDetailViewController

- (id)initWithExpert:(User *)expert {
    self = [super init];
    if (self) {
        [self setExpert:expert];
        self.currentUser = [User currentUser];
    }
    return self;
}

- (id)initWithExpert:(User *)expert modal:(Boolean)isModal {
    self = [super init];
    if (self) {
        [self setExpert:expert];
        self.currentUser = [User currentUser];
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
        self.currentUser = [User currentUser];
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
    
    [self.feedTable registerNib:[UINib nibWithNibName:@"ActivityLikeCell" bundle:nil] forCellReuseIdentifier:LikeCellIdent];
    
    self.feedTable.dataSource = self;
    self.feedTable.delegate = self;
    [self.feedTable setSeparatorInset:UIEdgeInsetsZero];


    self.isMyExpert = [Utils sameObjects:self.currentUser.currentTrainer object:self.expert];
    [self updateButtons];
    [self setupFeedTable];

    [self fetchActivityLikes];
    
    

    [self fetchData];
    
    // Style elements on profile
    self.profileImage.layer.cornerRadius= self.profileImage.frame.size.width/2;
    self.chatButton.layer.cornerRadius= 3;
    self.selectExpertButton.layer.cornerRadius= 3;
    self.navigationController.navigationBar.translucent = NO;
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

- (IBAction)onSelectExpert:(id)sender {
    self.isMyExpert = YES;
    [self.currentUser selectExpert:self.expert];
    [self updateButtons];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hasExpert" object:nil];
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

- (void)setupFeedTable {
    self.feedTable.layer.borderWidth = 1;
    self.feedTable.layer.borderColor = [Utils getGray].CGColor;
    self.feedTable.layer.cornerRadius = 6;
}

- (void)fetchActivityLikes {
    [ActivityLike getActivityLikesByUser:self.currentUser success:^(NSArray *activityLikes) {
        self.activityLikes = activityLikes;
        [self.feedTable reloadData];
    } error:^(NSError *error) {
        NSLog(@"Error fetching ActivityLikes %@", error);
    }];
}


- (void)fetchData {
    [self.expert fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.nameLabel.text = self.expert.email;
        if (self.expert.image) {
            [Utils loadImageFile:self.expert.image inImageView:self.profileImage withAnimation:NO];
        } else {
            [self.profileImage setImage:[self.expert getPlaceholderImage]];
        }
    }];
}

- (void)updateButtons {
    self.chatButton.hidden = !self.isMyExpert;
    self.selectExpertButton.hidden = self.isMyExpert;
}

#pragma mark UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.activityLikes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityLikeCell *cell = (ActivityLikeCell *)[tableView dequeueReusableCellWithIdentifier:LikeCellIdent];
    ActivityLike *like = self.activityLikes[indexPath.row];
    [cell setActivityLike:like];
    return cell;
}


@end
