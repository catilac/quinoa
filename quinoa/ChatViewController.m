//
//  ChatViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *chatView;
@property (weak, nonatomic) IBOutlet UITextField *chatInput;

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFUser *expert;

@end

@implementation ChatViewController

- (id)initWithUser:(PFUser *)user expert:(PFUser *)expert {
    self = [super init];
    if (self) {
        self.user = user;
        self.expert = expert;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSend:(id)sender {
    NSLog(@"CHAT: %@", self.chatInput.text);
}

@end
