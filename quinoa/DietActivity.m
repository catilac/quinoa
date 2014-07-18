//
//  DietActivity.m
//  quinoa
//
//  Created by Amie Kweon on 7/14/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "DietActivity.h"
#import "Utils.h"

@interface DietActivity ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *divider;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation DietActivity

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"DietActivity" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        [self addSubview:objects[0]];
    }
    return self;
}

- (void)setActivity:(Activity *)activity {
    _activity = activity;

    if (self.activity.image) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [Utils loadImageFile:self.activity.image inImageView:self.imageView withAnimation:YES];
    }
    self.descriptionLabel.text = self.activity.descriptionText;
    [self.descriptionLabel setTextColor:[Utils getDarkBlue]];
    self.divider.backgroundColor = [Utils getGray];
}

- (void)layoutSubviews {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 260, 500)];
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
