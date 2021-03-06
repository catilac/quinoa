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

@interface ClientRowCell () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActiveValueLabel;
@property (strong, nonatomic) UICollectionViewCell *containerCell;
@property (strong, nonatomic) BTBadgeView *badgeView;
@property (weak, nonatomic) IBOutlet UILabel *nudgeLabel;
@property (weak, nonatomic) IBOutlet UIView *nudgeContainer;
@property (weak, nonatomic) IBOutlet UIView *nudgeParentContainer;
@property (weak, nonatomic) IBOutlet UIImageView *nudgeOutline;

@property (weak, nonatomic) IBOutlet UIView *chatParentContainer;
@property (weak, nonatomic) IBOutlet UIView *chatContainerInactive;
@property (weak, nonatomic) IBOutlet UIImageView *chatIconOutline;


@end

@implementation ClientRowCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer* layer = self.layer;
        [layer setCornerRadius:3.0f];
        [layer setBorderWidth:1.0f];
        [layer setBorderColor:[Utils getGrayBorder].CGColor];
        [layer setBackgroundColor:[Utils getLightGray].CGColor];

        UINib *nib = [UINib nibWithNibName:@"ClientRowCell" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        
        self.containerCell = objects[0];
        [self.contentView addSubview:self.containerCell];
        [self.containerCell setFrame:self.contentView.frame];
        
        // Add gesture user cell
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onUserPan:)];
        [self addGestureRecognizer: panGestureRecognizer];
        panGestureRecognizer.delegate = self;
        
    }
    return self;
}

- (void)setClient:(User *)client {
    
    // set styles
    self.nameLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
    self.lastActiveLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
    self.lastActiveValueLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
    
    // set values
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
        [self.lastActiveValueLabel setTextColor:[Utils getRed]];
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
            self.badgeView = [[BTBadgeView alloc] initWithFrame:CGRectMake(40, 0, 40, 40)];
            self.badgeView.shadow = NO;
            self.badgeView.shine = NO;
            self.badgeView.fillColor = [Utils getRed];
            self.badgeView.strokeColor = [Utils getRed];
            self.badgeView.font = [UIFont fontWithName:@"Helvetica" size:16];
            self.badgeView.value = [NSString stringWithFormat:@"%@", count];
            [self.containerCell addSubview:self.badgeView];
            self.nudgeContainer.layer.opacity = 0;
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

- (IBAction)onUserPan:(UIPanGestureRecognizer *)sender {
    
    
    // Reset inactive container to full opacity
    self.chatContainerInactive.layer.opacity = 1;
    self.nudgeContainer.layer.opacity = 1;

    
    if (sender.state == UIGestureRecognizerStateBegan){
        
    } else if (sender.state == UIGestureRecognizerStateChanged){
    
        CGPoint translation = [sender translationInView:self.contentView];
        
        // Fade out nudgeOutline icon
        float nudgeDragOffest = sender.view.center.x - 160;
        self.nudgeOutline.layer.opacity = 1 - nudgeDragOffest/72;
        
        // Fade out chatOutline icon
        float chatDragOffest = (sender.view.center.x - 160) *-1;
        self.chatIconOutline.layer.opacity = 1 - chatDragOffest/62;

        // Create friction on pan
        sender.view.center = CGPointMake(sender.view.center.x + translation.x*.35, sender.view.center.y);
        [sender setTranslation:CGPointMake(0, 0) inView:self.contentView];

    } else if (sender.state == UIGestureRecognizerStateEnded){
        
        if (sender.view.center.x > 232) {
            
            // Fade fade out inactive nudge state
            [UIView animateWithDuration:.2 animations:^{
                self.nudgeContainer.layer.opacity = 0;
            }];

            //Animate Nudge Icon
            [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:15 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.nudgeParentContainer.layer.anchorPoint = CGPointMake(0.5, 0.5);
                self.nudgeParentContainer.layer.transform = CATransform3DScale(self.nudgeParentContainer.layer.transform, 1.25, 1.25, 1);
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:.2 animations:^{
                    self.nudgeParentContainer.layer.transform = CATransform3DScale(self.nudgeParentContainer.layer.transform, .8, .8, 1);
                }];
                
                // Build a query to match users with a birthday today
                PFQuery *innerQuery = [User query];

                // Use hasPrefix: to only match against the month/date
                [innerQuery whereKey:@"objectId" equalTo:self.client.objectId];

                // Build the actual push notification target query
                PFQuery *query = [PFInstallation query];
                [query whereKey:@"user" matchesQuery:innerQuery];

               PFPush *push = [[PFPush alloc] init];
                [push setQuery:query];
                [push setMessage:[NSString stringWithFormat:@"YO! from %@", [[User currentUser] firstName]]];
                [push sendPushInBackground];
            }];
            
            
            // Animate Cell back after delay
            [UIView animateWithDuration:.4 delay:.4 usingSpringWithDamping:.7 initialSpringVelocity:10 options: UIViewAnimationOptionAllowUserInteraction animations:^{
                sender.view.center = CGPointMake(160, sender.view.center.y);
                
            } completion:^(BOOL finished) {
                
                // Bring back nudge icon to full opacity
                self.nudgeContainer.layer.opacity = 1;
                
            }];
            
        } else if (sender.view.center.x < 98 ) {
            
            // Fade fade out inactive nudge state
            [UIView animateWithDuration:.2 animations:^{
                self.chatContainerInactive.layer.opacity = 0;
            }];
            
            //Animate Nudge Icon
            [UIView animateWithDuration:.2 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:15 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.chatParentContainer.layer.anchorPoint = CGPointMake(0.5, 0.5);
                self.chatParentContainer.layer.transform = CATransform3DScale(self.chatParentContainer.layer.transform, 1.25, 1.25, 1);
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:.2 animations:^{
                    self.chatParentContainer.layer.transform = CATransform3DScale(self.chatParentContainer.layer.transform, .8, .8, 1);
                }];
                
                [self.delegate loadChatView:self.client];
                
            }];
            
            // Animate Cell back after delay
            [UIView animateWithDuration:.4 delay:.4 usingSpringWithDamping:.7 initialSpringVelocity:10 options: UIViewAnimationOptionAllowUserInteraction animations:^{
                sender.view.center = CGPointMake(160, sender.view.center.y);
                
            } completion:^(BOOL finished) {
            }];

        
        } else {
            
            [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:10 options: UIViewAnimationOptionAllowUserInteraction animations:^{
                sender.view.center = CGPointMake(160, sender.view.center.y);
                
            } completion:^(BOOL finished) {
                NSLog(@"Animation Ended");
            }];
        }
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint velocity =[recognizer velocityInView:self];
    if(abs(velocity.y)>=(abs(velocity.x))){
        return NO;
    }else return YES;
    
}


@end
