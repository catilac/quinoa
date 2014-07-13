//
//  ActivitiesCollectionViewController.m
//  quinoa
//
//  Created by Amie Kweon on 7/12/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ActivitiesCollectionViewController.h"
#import "Activity.h"
#import "ActivityCell.h"

@interface ActivitiesCollectionViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *activities; // may have to change to NSMutableArray later on

@end

@implementation ActivitiesCollectionViewController

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

    [self.collectionView registerClass:[ActivityCell class] forCellWithReuseIdentifier:@"ActivityCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self fetchData];
    
    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.activities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCell"
                                                                 forIndexPath:indexPath];

    Activity *activity = self.activities[indexPath.row];
    cell.activityType = activity.activityType;

    return cell;
}

- (void)fetchData {
    [Activity getActivitiesByUser:[PFUser currentUser] success:^(NSArray *objects) {
        self.activities = objects;
        [self.collectionView reloadData];
    } error:^(NSError *error) {
        NSLog(@"[ActivitiesCollection] error: %@", error.description);
    }];
}


@end
