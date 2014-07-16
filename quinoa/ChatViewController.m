//
//  ChatViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ChatViewController.h"
#import "Message.h"
#import "ChatCell.h"
#import "UILabel+QuinoaLabel.h"

@interface ChatViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *chatView;
@property (weak, nonatomic) IBOutlet UITextField *chatInput;

@property (strong, nonatomic) User *recipient;
@property (strong, nonatomic) NSArray *messages;
@property (strong, nonatomic) NSTimer *queryTimer;

@end

@implementation ChatViewController

static NSString *CellIdentifier = @"chatCellIdent";

- (id)initWithUser:(User *)recipient {
    self = [super init];
    if (self) {
        self.recipient = recipient;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Chat";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.chatView registerNib:[UINib nibWithNibName:@"ChatCell" bundle:nil]
    forCellWithReuseIdentifier:CellIdentifier];
    
    self.chatView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(300, 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.chatView setCollectionViewLayout:flowLayout];

    
    
    self.queryTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(fetchMessages)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.queryTimer) {
        [self.queryTimer invalidate];
        self.queryTimer = nil;
    }
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSend:(id)sender {
    [Message sendMessageToUser:self.recipient
                      fromUser:[User currentUser]
                       message:self.chatInput.text];
    self.chatInput.text = @"";
}

- (void)fetchMessages {
    NSString *threadId = [Message calcThreadIdWithSender:[User currentUser] recipient:self.recipient];
    [Message getMessagesByThreadId:threadId success:^(NSArray *messages) {
        self.messages = messages;
        [self.chatView reloadData];
    } error:^(NSError *error) {
        NSLog(@"ERROR");
    }];
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                           forIndexPath:indexPath];
    Message *message = self.messages[indexPath.row];
    [cell updateChatCellWithMessage:message];
    return cell;
}


@end
