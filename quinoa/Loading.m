//
//  Loading.m
//  quinoa
//
//  Created by Joseph Lee on 8/3/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "Loading.h"
#import "Utils.h"

@interface Loading ()

@property (strong, nonatomic) UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *nutritionImage;
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@property (weak, nonatomic) IBOutlet UIImageView *weightImage;
@property (nonatomic, assign) BOOL isActive;

@end

@implementation Loading

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UINib *nib = [UINib nibWithNibName:@"Loading" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        self.contentView = objects[0];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView setFrame:frame];
        [self addSubview:self.contentView];
        self.isActive = NO;

    }
    return self;
}

- (void)startAnimation {
    
    /*[UIView animateWithDuration:1 delay:5 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionRepeat animations:^{
        [self nutritionActive:self];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1 delay:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self activityActive:self];
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1 delay:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self weightActive:self];
            } completion:^(BOOL finished) {
                
            }];
            
        }];
        
    }];*/
    self.isActive = YES;
    [self nutritionActive];
    
    
}

- (void)nutritionActive {
    
    if(self.isActive) {
        self.nutritionImage.image = [UIImage imageNamed:@"composeDiet.png"];
        self.activityImage.image = [UIImage imageNamed:@"composeActivityInactive.png"];
        self.weightImage.image = [UIImage imageNamed:@"composeWeightInactive.png"];
        
        [self performSelector:@selector(activityActive) withObject:nil afterDelay:.4];
    }
}

- (void)activityActive {
    
    if(self.isActive) {
        self.nutritionImage.image = [UIImage imageNamed:@"composeDietInactive.png"];
        self.activityImage.image = [UIImage imageNamed:@"composeActivity.png"];
        self.weightImage.image = [UIImage imageNamed:@"composeWeightInactive.png"];
        
        [self performSelector:@selector(weightActive) withObject:nil afterDelay:.4];
    }
}

- (void)weightActive {
    
    if(self.isActive) {
        self.nutritionImage.image = [UIImage imageNamed:@"composeDietInactive.png"];
        self.activityImage.image = [UIImage imageNamed:@"composeActivityInactive.png"];
        self.weightImage.image = [UIImage imageNamed:@"composeWeight.png"];
        
        [self performSelector:@selector(nutritionActive) withObject:nil afterDelay:.4];
    }
}

- (void)stopActive {
    self.isActive = NO;
}

- (void)hideIcons {
    self.nutritionImage.alpha = 0;
    self.activityImage.alpha = 0;
    self.weightImage.alpha = 0;
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
