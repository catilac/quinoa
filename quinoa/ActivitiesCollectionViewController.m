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
#import "ProfileCell.h"
#import "UILabel+QuinoaLabel.h"
#import "Utils.h"

@interface ActivitiesCollectionViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *activities; // may have to change to NSMutableArray later on

@property (nonatomic, strong) ActivityCell *stubCell;

@end

@implementation ActivitiesCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (self.user == nil) {
            self.user = [User currentUser];
        }
        self.title = self.user.firstName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];

    [self.collectionView registerClass:[ActivityCell class] forCellWithReuseIdentifier:@"ActivityCell"];
    [self.collectionView registerClass:[ProfileCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfileCell"];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self fetchData];

    self.stubCell = [[ActivityCell alloc] init];
    
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
    cell.activity = activity;

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    self.stubCell.activity = self.activities[indexPath.row];
    CGSize size = [self.stubCell intrinsicContentSize];
    size.width = self.collectionView.frame.size.width - 20;
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        ProfileCell *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProfileCell" forIndexPath:indexPath];

        headerView.user = self.user;
        reusableView = headerView;
    }
    return reusableView;
}

- (void)fetchData {
    [Activity getActivitiesByUser:self.user success:^(NSArray *objects) {
        self.activities = objects;
        NSLog(@"activities count: %d", self.activities.count);
        [self.collectionView reloadData];
    } error:^(NSError *error) {
        NSLog(@"[ActivitiesCollection] error: %@", error.description);
    }];
}

- (void)setupUI {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundView = view;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setItemSize:CGSizeMake(self.view.frame.size.width, 200)];
    [flowLayout setHeaderReferenceSize:CGSizeMake(self.view.frame.size.width, 200)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 0, 10)];
    [self.collectionView setCollectionViewLayout:flowLayout];
}

@end
