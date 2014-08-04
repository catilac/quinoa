//
//  ExpertBrowserViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ExpertBrowserViewController.h"
#import <Parse/Parse.h>
#import "ExpertDetailViewController.h"
#import "UILabel+QuinoaLabel.h"
#import "ChatViewController.h"

@interface ExpertBrowserViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *expertCollection;

@property (strong, nonatomic) NSArray *experts;

@property (strong, nonatomic) User *currentUser;

@end

@implementation ExpertBrowserViewController

static NSString *CellIdentifier = @"ExpertCellIdent";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Browse Experts";
        self.currentUser = [User currentUser];
        NSLog(@"DEBUG USER: %@", self.currentUser.currentTrainer);
        if (self.currentUser.currentTrainer) {
            UIBarButtonItem *trainerButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(showCurrentTrainer)];
            self.navigationItem.leftBarButtonItem = trainerButton;
        }
    }
    return self;
}

- (id)initIsModal:(Boolean)isModal {
    self = [super init];
    if (self) {
        self.isModal = isModal;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *expertCellNib = [UINib nibWithNibName:@"ExpertCell" bundle:nil];
    [UINib nibWithNibName:@"ExpertCell" bundle:nil];
    [self.expertCollection registerNib:expertCellNib
            forCellWithReuseIdentifier:CellIdentifier];

    self.expertCollection.dataSource = self;
    
    // Setup Layout for UICollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(280, 400)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.expertCollection setCollectionViewLayout:flowLayout];
    
    // Spacing for flowlayout
    [flowLayout setMinimumLineSpacing:20];
    [flowLayout setHeaderReferenceSize:CGSizeMake(20, 20)];
    [flowLayout setFooterReferenceSize:CGSizeMake(20, 20)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(-90, 0, 0, 0)];

    
    [self fetchExperts];
    
    // Set status bar to white
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;

}

- (void)fetchExperts {
    PFQuery *query = [User query];
    [query whereKey:@"role" containsString:@"expert"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.experts = objects;
            [self.expertCollection reloadData];
        } else {
            NSLog(@"Error Fetching Experts: %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCurrentTrainer {
    if (self.isModal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        User *expert = self.currentUser.currentTrainer;
        //[expert fetch]; I don't think fetch is necessary
        
        ExpertDetailViewController *expertDetail = [[ExpertDetailViewController alloc] initWithExpert:expert modal:YES];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:expertDetail];
        [self presentViewController:nc animated:YES completion:^{
            NSLog(@"Presented");
        }];
    }

}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.experts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ExpertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                 forIndexPath:indexPath];
    [cell setValuesWithExpert:self.experts[indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

# pragma mark - ExpertCellDelegate methods

- (void)selectExpert:(User *)expert {
    [self.currentUser selectExpert:expert];
    
    //UIViewController *chatViewController;
    //chatViewController = [[ChatViewController alloc] initWithUser:expert];
    //[self.navigationController pushViewController:chatViewController animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hasExpert" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
