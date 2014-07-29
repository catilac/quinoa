//
//  ClientRowCell.m
//  quinoa
//
//  Created by Amie Kweon on 7/27/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ClientRowCell.h"
#import "UILabel+QuinoaLabel.h"
#import "Utils.h"
#import "DateTools.h"
#import "BTBadgeView.h"

@interface ClientRowCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActiveValueLabel;
@property (strong, nonatomic) UICollectionViewCell *containerCell;
@property (strong, nonatomic) BTBadgeView *badgeView;

@end

@implementation ClientRowCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer* layer = self.layer;
        [layer setCornerRadius:3.0f];
        [layer setBorderWidth:1.0f];
        [layer setBorderColor:[Utils getGray].CGColor];
        [layer setBackgroundColor:[Utils getLightGray].CGColor];

        UINib *nib = [UINib nibWithNibName:@"ClientRowCell" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];

        self.containerCell = objects[0];
        [self.contentView addSubview:self.containerCell];
        [self.containerCell setFrame:self.contentView.frame];
    }
    return self;
}

- (void)setClient:(User *)client {
    _client = client;

    if (self.client.image) {
        [Utils loadImageFile:self.client.image inImageView:self.imageView withAnimation:YES];
    } else {
        [self.imageView setImage:[UIImage imageNamed:@"avatar"]];
    }
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;

    self.nameLabel.text = [self.client getDisplayName];
    self.lastActiveValueLabel.text = [[[self.client lastActiveAt] timeAgoSinceNow] lowercaseString];
    NSDate *today = [NSDate date];
    if ([today daysFrom:self.client.lastActiveAt] > 21) {
        [self.lastActiveValueLabel setTextColor:[UIColor redColor]];
    } else {
        [self.lastActiveValueLabel setTextColor:[Utils getDarkerGray]];
    }

    [self.nameLabel setTextColor:[Utils getDarkBlue]];
    [self.lastActiveLabel setTextColor:[Utils getDarkerGray]];

    // There's a weird bug here. After scrolling for a while, "BAD ACCESS" error
    // occurs with accessing `newMessageCount`
    if ([self.client class] == [User class] && [self.client objectForKey:@"newMessageCount"] != nil) {
        NSNumber *count = [self.client newMessageCount];
        if (count != nil) {
            self.badgeView = [[BTBadgeView alloc] initWithFrame:CGRectMake(50, 5, 40, 40)];
            self.badgeView.shadow = NO;
            self.badgeView.shine = NO;
            self.badgeView.fillColor = [Utils getRed];
            self.badgeView.strokeWidth = 0;
            self.badgeView.font = [UIFont fontWithName:@"Helvetica" size:14];
            self.badgeView.value = [NSString stringWithFormat:@"%@", count];
            [self.containerCell addSubview:self.badgeView];
        }
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
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
