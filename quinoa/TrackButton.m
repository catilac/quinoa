//
//  TrackButton.m
//  quinoa
//
//  Created by Chirag Davé on 7/14/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "TrackButton.h"
#import "Utils.h"

@interface TrackButton ()

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (assign) Boolean menuOpen;

@end

@implementation TrackButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:NO];
        
        // Set track button properties
        [self setBackgroundColor:[Utils getGreen]];
        UIImageView *trackImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"track"]];
        trackImage.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 25);
        
        [self addSubview:trackImage];
        
        // Initialize TapGesture to handle closing the menu
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                     action:@selector(closeMenu)];
        [self addGestureRecognizer:self.tapRecognizer];
        
        // Handle notification for when menu is open
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(openMenu)
                                                     name:kOpenMenu
                                                   object:nil];
    }
    return self;
}

- (void)openMenu {
    self.backgroundColor = [UIColor redColor];
    [self setUserInteractionEnabled:YES];
}

- (void)closeMenu {
    [self setUserInteractionEnabled:NO];
    self.backgroundColor = [Utils getGreen];
    
    // Send out a message saying we're closing the menu
    // The LoginViewController will be listening for it, and will swap us back to the last tab bar in use.
    [[NSNotificationCenter defaultCenter] postNotificationName:kCloseMenu object:nil];

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
