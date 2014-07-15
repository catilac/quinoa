//
//  TrackButton.m
//  quinoa
//
//  Created by Chirag Davé on 7/14/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "TrackButton.h"

@interface TrackButton ()

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (assign) Boolean armed;

@end

@implementation TrackButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:NO];
        [self setBackgroundColor:[UIColor redColor]];
        
        _armed = NO;
        
        // Initialize TapGesture
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                     action:@selector(sendSubmitMessage)];
        [self addGestureRecognizer:self.tapRecognizer];
        
        // Arm Trigger
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(readyToSubmit)
                                                     name:kReadyToSubmitMessage
                                                   object:nil];
        // Disarm Trigger
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notReadyToSubmit)
                                                     name:kNotReadyToSubmitMessage
                                                   object:nil];
    }
    return self;
}

- (void)readyToSubmit {
    [self setBackgroundColor:[UIColor colorWithRed:0.278 green:0.651 blue:0.839 alpha:1]];
    self.armed = YES;
    [self setUserInteractionEnabled:YES];
}

- (void)notReadyToSubmit {
    [self setBackgroundColor:[UIColor redColor]];
}

- (void)sendSubmitMessage {
    if (self.armed) {
        self.armed = NO;
        [self setUserInteractionEnabled:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSubmitData
                                                            object:nil];
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
