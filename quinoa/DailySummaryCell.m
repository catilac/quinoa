//
//  DailySummaryCell.m
//  quinoa
//
//  Created by Hemen Chhatbar on 7/19/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "DailySummaryCell.h"
#import "Activity.h"
#import "Utils.h"

@interface DailySummaryCell ()

@property (weak, nonatomic) IBOutlet UILabel *activityDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;


@end


@implementation DailySummaryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"DailySummaryCell" owner:self options:nil];
        
//        if ([arrayOfViews count] < 1) {
//            return nil;
//        }
//        
//        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
//            return nil;
//        }
        [self addSubview:arrayOfViews[0]];
        //self = [arrayOfViews objectAtIndex:0];
        
    }

    return self;
}

- (void)setWeightActivity:(NSDictionary *)activity {
    /*_weightActivity = activity;
    
    self.weightLabel.text = @"HIII";
    
    //self.weightLabel.text = [NSString stringWithFormat:@"%i", [self.weightActivity.activityValue intValue]];
    [self.weightLabel setTextColor:[Utils getGreen]];
    self.weightLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:38]; */
    
    for (NSString* key in activity) {
        id value = [activity objectForKey:key];
        // do stuff
        NSLog(@"value - %@", value);
    }

}

- (void)setActivity:(NSDictionary *)dictionary {
    
    for (NSString* key in dictionary) {
        Activity *activity = [dictionary objectForKey:key];
        // do stuff
        // 0 is food pic
        // 1 is weight
        // 2 is p.activity
        //if([key isEqualToString:@"0"])
       // {
        
       // }
        
            if (activity.activityType == ActivityTypeWeight)
            {
                self.weightLabel.text = [NSString stringWithFormat:@"%@", activity.activityValue];
                
            }
           
        if (activity.activityType == ActivityTypePhysical)
        {
            self.activityDurationLabel.text = [NSString stringWithFormat:@"%@", activity.activityValue];
           
        }
    
        
      //  NSLog(@"value - %@", value[@"activityValue"]);
    }
    }
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
