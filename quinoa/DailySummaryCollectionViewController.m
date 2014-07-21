//
//  DailySummaryCollectionViewController.m
//  quinoa
//
//  Created by Hemen Chhatbar on 7/19/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "DailySummaryCollectionViewController.h"
#import "Activity.h"
#import "ActivityCell.h"
#import "ProfileCell.h"
#import "UILabel+QuinoaLabel.h"
#import "Utils.h"
#import "DailySummaryCell.h"
#import "DailyActivity.h"



@interface DailySummaryCollectionViewController ()
{
    BOOL isExpertView;
}

@property (strong, nonatomic) NSArray *activities;
@property (strong, nonatomic) NSMutableArray *dateKeyArray;
@property (strong, nonatomic) NSMutableDictionary *activityDictionary;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//@property (weak, nonatomic) IBOutlet UIView *weeklySummaryView;
//@property (weak, nonatomic) IBOutlet UIView *weeklySummaryView;




@end


@implementation DailySummaryCollectionViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    

   
    if (self) {
        self.user = [User currentUser];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        self.collectionView.backgroundView = view;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
       // [flowLayout setItemSize:CGSizeMake(300, 240)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        [self.collectionView setCollectionViewLayout:flowLayout];
        [self.collectionView registerClass:[DailySummaryCell class] forCellWithReuseIdentifier:@"DailySummaryCell"];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundView = view;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(300, 240)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerClass:[DailySummaryCell class] forCellWithReuseIdentifier:@"DailySummaryCell"];
    self.collectionView.dataSource = self;
    //[self fetchData];
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
        NSLog(@"view did appear.....");
    [self fetchData];
    //[self.collectionView setContentOffset:CGPointZero animated:NO];
    [super viewDidAppear:animated];
}


- (void)fetchData {
    // TODO: Add paging here
    NSLog(@"fetch data.....");
    self.activityDictionary = [[NSMutableDictionary alloc] init];
    self.dateKeyArray = [[NSMutableArray alloc]init];
    
    //[Activity getLatestActivityByUser:self.user byActivity:(ActivityTypeWeight) quantity:7 success:^(NSArray *objects) {
        [Activity getActivitiesByUser:self.user success:^(NSArray *objects) {

        //[Activity getActivitiesByUser:self.user success:^(NSArray *objects) {
        self.activities = objects;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"dd-MM-yyyy";
        NSString *dateKey;
        //NSString *activityDate;
        
        //NSLog(@"%@", [format stringFromDate:activity.updatedAt]);

        for(id object in self.activities)
        {
            Activity *activity = object;
            
            dateKey = [format stringFromDate:activity.updatedAt];
        if (![self.dateKeyArray containsObject:dateKey])
            [self.dateKeyArray addObject:dateKey];
        }
        
        for(Activity *activity in self.activities)
        {
            dateKey = [format stringFromDate:activity.updatedAt];

            NSMutableDictionary *entry  = [self.activityDictionary objectForKey:dateKey];
            if (entry == nil) {
                // create from scrach
                entry = [[NSMutableDictionary alloc] init];
                entry[@(activity.activityType)] = activity;
                
            } else {
                if (![entry objectForKey:@(activity.activityType)]) {
                    entry[@(activity.activityType)] = activity;
                }
            }
            self.activityDictionary[dateKey] = entry;
            
        }
        
        NSLog(@"my weight activities count: %d", self.activities.count);
        [self.collectionView reloadData];
    } error:^(NSError *error) {
        NSLog(@"[Weight ActivitiesCollection my activities] error: %@", error.description);
    }];
    

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 7;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"DailySummaryCell";
    
    DailySummaryCell *cell = (DailySummaryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    //Activity *activity = self.activities[indexPath.row];
    
    NSString *dateKey = self.dateKeyArray[indexPath.row];
    NSDictionary *activityDict = [self.activityDictionary objectForKey:dateKey];
    
    cell.dictionary =  [self.activityDictionary objectForKey:dateKey];
    [cell setActivity:activityDict];
 
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd-MM-yyyy";
    


    //NSLog(@"%@", [format stringFromDate:activity.updatedAt]);
    
//    NSLog(@"activity Date - %@", activity.updatedAt );
    //NSLog(@"Physical activity value - %@", physicalActivity.activityValue );
    //NSLog(@"Food activity comment - %@", foodActivity.descriptionText );
    //cell.weight = [NSString stringWithFormat:@"%i", [weightActivity.activityValue intValue]];;
    //cell.weightActivity = activity;
      
    return cell;
}


@end
