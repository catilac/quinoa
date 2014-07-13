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
    [self.delegate showExpertDetail:self.expert];
}

-(void)setValuesWithExpert:(PFUser *)expert {
    self.expert = expert;
    self.nameLabel.text = expert.email;
    
    // Profile card element styling
    self.profileButton.layer.cornerRadius = 3;
    self.cardBackground.layer.cornerRadius = 6;
    self.profileImage.layer.cornerRadius = 53;
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
