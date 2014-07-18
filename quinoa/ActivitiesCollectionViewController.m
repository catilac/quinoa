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

static const CGFloat UserHeaderHeight = 65;
static const CGFloat ActivitySectionHeight = 60;
static const CGFloat DividerHeight = 30;
static const CGFloat ImageDimension = 260;

@interface ActivitiesCollectionViewController ()
{
    BOOL isExpertView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *activities; // may have to change to NSMutableArray later on

@end

@implementation ActivitiesCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (self.user == nil) {
            self.user = [User currentUser];
            isExpertView = [self.user isExpert];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.activities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCell"
                                                                 forIndexPath:indexPath];
    Activity *activity = self.activities[indexPath.row];
    [cell setActivity:activity showHeader:isExpertView];

    return cell;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [self cellHeight:self.activities[indexPath.row]];
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
    // TODO: Add paging here
    if (self.activities > 0) {
        return;
    }
    if (isExpertView) {
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

- (CGSize)cellHeight:(Activity *)activity {
    CGSize size = CGSizeMake(self.collectionView.frame.size.width - 20, 0);
    if (activity.activityType == ActivityTypeEating) {
        size.height += ImageDimension;
    }
    if (activity.activityType != ActivityTypeWeight && [activity.descriptionText length] > 0) {
        NSDictionary *dict = @{NSFontAttributeName: [UIFont fontWithName:@"SourceSansPro-Regular" size:13]};
        CGRect rect = [activity.descriptionText boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        size.height += rect.size.height + DividerHeight;
    }
    size.height += ActivitySectionHeight;
    if (isExpertView) {
        size.height += UserHeaderHeight;
    }
    NSLog(@"type: %i - %f", activity.activityType, size.height);
    return size;
}

@end
