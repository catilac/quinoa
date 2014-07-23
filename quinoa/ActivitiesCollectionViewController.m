//
//  ActivitiesCollectionViewController.m
//  quinoa
//
//  Created by Amie Kweon on 7/12/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ActivitiesCollectionViewController.h"
#import "ProfileViewController.h"
#import "Activity.h"
#import "ActivityLike.h"
#import "ActivityCell.h"
#import "ProfileCell.h"
#import "UILabel+QuinoaLabel.h"
#import "Utils.h"

@interface ActivitiesCollectionViewController ()
{
    BOOL isExpertView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) ActivityCell *stubCell;
@property (strong, nonatomic) NSArray *activities; // may have to change to NSMutableArray later on
@property (strong, nonatomic) NSMutableArray *likes;
@end

@implementation ActivitiesCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (self.user == nil) {
            self.user = [User currentUser];
            isExpertView = [self.user isExpert];
            self.stubCell = [[ActivityCell alloc] init];
        }
        self.title = self.user.firstName;
        self.likes = [[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onActivityLiked:)
                                                     name:@"activityLiked"
                                                   object:nil];
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
    
    self.title = @"Activity";

    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [self fetchData];
    [self.collectionView setContentOffset:CGPointZero animated:NO];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.activities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCell"
                                                                 forIndexPath:indexPath];
    Activity *activity = self.activities[indexPath.row];
    cell.liked = [self liked:activity];
    [cell setActivity:activity showHeader:YES showLike:isExpertView];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    [self.stubCell setActivity:self.activities[indexPath.row] showHeader:YES showLike:isExpertView];
    CGSize size = [self.stubCell cellSize];

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

- (void)onActivityLiked:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"activityLiked"]) {
        NSDictionary *activityData = [notification valueForKey:@"object"];
        Activity *activity = activityData[@"activity"];
        User *expert = activityData[@"expert"];
        if ([activityData[@"liked"] isEqual:@(YES)]) {
            NSLog(@"[ActivitiesCollection] liked");
            [ActivityLike likeActivity:activity user:activity.user expert:expert];
            [self.likes addObject:activity.objectId];
        } else {
            NSLog(@"[ActivitiesCollection] unliked");
            [ActivityLike unlikeActivity:activity expert:expert];
            [self.likes removeObject:activity.objectId];
        }
    }
}

- (void)fetchData {
    // TODO: Add paging here
    if (isExpertView) {
        [self fetchActivityLikes];
        [Activity getClientActivitiesByExpert:self.user success:^(NSArray *objects) {
            self.activities = objects;
            NSLog(@"client activities count: %d", self.activities.count);
            [self.collectionView reloadData];
        } error:^(NSError *error) {
            NSLog(@"[ActivitiesCollection clients] error: %@", error.description);
        }];
    } else {
        [Activity getActivitiesByUser:self.user success:^(NSArray *objects) {
            self.activities = objects;
            NSLog(@"my activities count: %d", self.activities.count);
            [self.collectionView reloadData];
        } error:^(NSError *error) {
            NSLog(@"[ActivitiesCollection my activities] error: %@", error.description);
        }];
    }
}

- (void)fetchActivityLikes {
    [ActivityLike getActivityLikesByExpert:self.user success:^(NSArray *activityLikes) {
        for (ActivityLike *activityLike in activityLikes) {
            [self.likes addObject:activityLike.activity.objectId];
        }
        NSLog(@"activityLikes count: %d", self.likes.count);
    } error:^(NSError *error) {
        NSLog(@"[ActivitiesCollection activityLikes] error: %@", error.description);
    }];
}

- (void)setupUI {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundView = view;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setHeaderReferenceSize:CGSizeMake(self.view.frame.size.width, 200)];
    [flowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 0, 10)];
    [self.collectionView setCollectionViewLayout:flowLayout];

    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Edit Profile"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(showProfile:)];
    self.navigationItem.rightBarButtonItem = profileButton;
}

- (void)showProfile:(id)sender {
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    [self presentViewController:navBar animated:YES completion:nil];
}

- (BOOL)liked:(Activity *)activity {
    return [self.likes indexOfObject:activity.objectId] != NSNotFound;
}

@end
