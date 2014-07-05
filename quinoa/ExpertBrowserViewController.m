//
//  ExpertBrowserViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ExpertBrowserViewController.h"
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
    // Do any additional setup after loading the view from its nib.
    
    [self.expertCollection registerClass:[UICollectionViewCell class]
              forCellWithReuseIdentifier:CellIdentifier];
    
    self.expertCollection.delegate = self;
    self.expertCollection.dataSource = self;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.expertCollection.frame];
    [backgroundView setBackgroundColor:[UIColor redColor]];
    self.expertCollection.backgroundView = backgroundView;
    
    [self fetchExperts];
}

- (void)fetchExperts {
    PFQuery *query = [PFUser query];
    [query whereKey:@"role" containsString:@"expert"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Success: %@", objects);
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.experts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                           forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}



@end
