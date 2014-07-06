//
//  ExpertCell.m
//  quinoa
//
//  Created by Chirag Davé on 7/5/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ExpertCell.h"

@implementation ExpertCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
    }
    return self;
}

- (IBAction)onSelect:(id)sender {
    NSLog(@"Trainer Selected");
}

-(void)setValuesWithExpert:(PFUser *)expert {
    self.expert = expert;
    self.nameLabel.text = expert.email;
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
