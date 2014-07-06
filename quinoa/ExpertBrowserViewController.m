//
//  ExpertBrowserViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ExpertBrowserViewController.h"
#import "ExpertCell.h"
#import <Parse/Parse.h>

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
        // Custom initialization
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

    self.expertCollection.delegate = self;
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

#pragma mark - UICollectionViewDelegate methods

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
    
    return cell;
    
}



@end
