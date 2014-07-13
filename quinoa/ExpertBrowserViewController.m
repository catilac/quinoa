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

@interface ExpertBrowserViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *expertCollection;

@property (strong, nonatomic) NSArray *experts;

@end

@implementation ExpertBrowserViewController

static NSString *CellIdentifier = @"ExpertCellIdent";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Browse Experts";
        PFUser *user = [PFUser currentUser];
        NSLog(@"DEBUG USER: %@", user[@"currentTrainer"]);
        if ([user objectForKey:@"currentTrainer"]) {
            UIBarButtonItem *trainerButton = [[UIBarButtonItem alloc] initWithTitle:@"My Trainer"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(showCurrentTrainer)];
            self.navigationItem.rightBarButtonItem = trainerButton;
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
    [flowLayout setItemSize:CGSizeMake(300, 400)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.expertCollection setCollectionViewLayout:flowLayout];
    
    [self fetchExperts];
}

- (void)fetchExperts {
    PFQuery *query = [PFUser query];
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
        PFUser *expert = [[PFUser currentUser] objectForKey:@"currentTrainer"];
        [expert fetch];
        
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

- (void)showExpertDetail:(PFUser *)expert {
    ExpertDetailViewController *expertView = [[ExpertDetailViewController alloc] initWithExpert:expert modal:self.isModal];
    [self.navigationController pushViewController:expertView animated:YES];
}



@end
