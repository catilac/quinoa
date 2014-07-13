//
//  MyClientsViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "MyClientsViewController.h"
#import "ClientCell.h"
#import <Parse/Parse.h>
#import "UILabel+QuinoaLabel.h"

@interface MyClientsViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *myClientsCollection;
@property (strong, nonatomic) NSArray *clients;

@end

@implementation MyClientsViewController

static NSString *CellIdentifier = @"clientCellIdent";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"My Clients";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.myClientsCollection registerNib:[UINib nibWithNibName:@"ClientCell" bundle:nil]
               forCellWithReuseIdentifier:CellIdentifier];
    
    self.myClientsCollection.dataSource = self;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(150, 146)];
    
    // Spacing for flowlayout
    [flowLayout setMinimumLineSpacing:20];
    [flowLayout setHeaderReferenceSize:CGSizeMake(20, 20)];
    [flowLayout setFooterReferenceSize:CGSizeMake(20, 20)];
    
    [self.myClientsCollection setCollectionViewLayout:flowLayout];
    
    [self fetchClients];
    
    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchClients {
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    [query whereKey:@"currentTrainer" equalTo:currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.clients = objects;
            [self.myClientsCollection reloadData];
        } else {
            NSLog(@"Error Fetching Clients: %@", error);
        }
    }];
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.clients count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClientCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                 forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setValuesWithClient:self.clients[indexPath.row]];
    return cell;
}


@end
