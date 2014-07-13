//
//  ActivityCell.m
//  quinoa
//
//  Created by Amie Kweon on 7/12/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ActivityCell.h"

@implementation ActivityCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setActivityType:(ActivityType)activityType {
    _activityType = activityType;

    NSString *nibName = @"";
    switch (_activityType) {
        case Eating:
            nibName = @"Eating";
            break;
        case Physical:
            nibName = @"Physical";
            break;
        case Weight:
            nibName = @"Weight";
            break;
    }

    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    NSArray *objects = [nib instantiateWithOwner:self options:nil];
    [self addSubview:objects[0]];
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
