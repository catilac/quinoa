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
#import "Utils.h"

@interface ChatViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *chatView;
@property (weak, nonatomic) IBOutlet UITextField *chatInput;
@property (weak, nonatomic) IBOutlet UIView *inputContainer;

@property (strong, nonatomic) User *recipient;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSTimer *queryTimer;

@property (strong, nonatomic) ChatCell *stubCell;

@property (assign) Boolean keyboardOut;
@property (assign) CGSize kbSize;

- (void)willShowKeyboard:(NSNotification *)notification;
- (void)willHideKeyboard:(NSNotification *)notification;
- (IBAction)onViewTap:(UITapGestureRecognizer *)sender;

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
        
        self.messages = [[NSMutableArray alloc] init];
        
        self.stubCell = [[ChatCell alloc] init];
        
        // Register the methods for the keyboard hide/show events
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
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
    self.chatView.delegate = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self.chatView setCollectionViewLayout:flowLayout];
    
    self.queryTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(fetchMessages)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)viewDidLayoutSubviews {
    // If the keyboard is out, maintain the correct frame for these items.
    // This is definitely a code smell, nobody knows why the frames keep popping back to their original
    // dimensions.
    if (self.keyboardOut) {
        self.chatView.frame = CGRectMake(self.chatView.frame.origin.x,
                                         self.chatView.frame.origin.y,
                                         self.chatView.frame.size.width,
                                         self.chatView.frame.size.height - self.kbSize.height + self.tabBarController.tabBar.frame.size.height);

        self.inputContainer.frame = CGRectMake(self.inputContainer.frame.origin.x,
                                         self.inputContainer.frame.origin.y - self.kbSize.height + self.tabBarController.tabBar.frame.size.height,
                                         self.inputContainer.frame.size.width,
                                         self.inputContainer.frame.size.height);
    }
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
    // reset the other user's message count since i'm reading it here
    [self.recipient resetNewMessageCount];
    NSString *threadId = [Message calcThreadIdWithSender:[User currentUser] recipient:self.recipient];
    [Message getMessagesByThreadId:threadId
                              skip:[self.messages count]
                           success:^(NSArray *newMessages) {
                               [self.chatView performBatchUpdates:^{
                                   NSInteger resultSize = [self.messages count];
                                   [self.messages addObjectsFromArray:newMessages];
                                   
                                   NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
                                   for (NSInteger i = resultSize; i < resultSize + newMessages.count; i++) {
                                       [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                   }
                                   
                                   [self.chatView insertItemsAtIndexPaths:arrayWithIndexPaths];
                               } completion:^(BOOL finished) {
                                   [self scrollToBottom];
                               }];
                           } error:^(NSError *error) {
                               NSLog(@"ERROR");
                           }];
}

- (void)scrollToBottom {
    NSInteger section = 0;
    NSInteger item = [self collectionView:self.chatView numberOfItemsInSection:section] - 1;
    if (item == -1) {
        return;
    }
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    [self.chatView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}

- (void)willShowKeyboard:(NSNotification *)notification {
    
    self.keyboardOut = YES;

    NSDictionary *userInfo = [notification userInfo];
    
    // Get the keyboard height and width from the notification
    // Size varies depending on OS, language, orientation
    self.kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.inputContainer.frame = CGRectMake(self.inputContainer.frame.origin.x,
                                                                self.inputContainer.frame.origin.y - self.kbSize.height + self.tabBarController.tabBar.frame.size.height,
                                                                self.inputContainer.frame.size.width,
                                                                self.inputContainer.frame.size.height);
                         
                         self.chatView.frame = CGRectMake(self.chatView.frame.origin.x,
                                                          self.chatView.frame.origin.y,
                                                          self.chatView.frame.size.width,
                                                          self.chatView.frame.size.height - self.kbSize.height + self.tabBarController.tabBar.frame.size.height);
                     }
                     completion:nil];
}


- (void)willHideKeyboard:(NSNotification *)notification {
    
    self.keyboardOut = NO;
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;

    
    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.inputContainer.frame = CGRectMake(self.inputContainer.frame.origin.x,
                                                                self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - self.inputContainer.frame.size.height + self.navigationController.navigationBar.frame.size.height + 5,
                                                                self.inputContainer.frame.size.width,
                                                                self.inputContainer.frame.size.height);
                         
                         self.chatView.frame = CGRectMake(self.chatView.frame.origin.x,
                                                          self.chatView.frame.origin.y,
                                                          self.chatView.frame.size.width,
                                                          self.chatView.frame.size.height + self.kbSize.height - self.tabBarController.tabBar.frame.size.height);
                         
                     }
                     completion:nil];
}

- (IBAction)onViewTap:(UITapGestureRecognizer *)sender {
    // get touch location
    CGPoint touchPosition = [sender locationInView:self.view];
    
    if(touchPosition.y < self.inputContainer.frame.origin.y) {
        // dismiss keyboard
        [self.view endEditing:YES];
    }
    
}
#pragma mark - UICollectionViewDelegateFlowLayout methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.stubCell updateChatCellWithMessage:self.messages[indexPath.row]];
    CGSize size = [self.stubCell cellSize];
    
    return size;
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
    
    cell.layer.cornerRadius = 6;
    
    Message *message = self.messages[indexPath.row];
    [cell updateChatCellWithMessage:message];
    return cell;
}




@end
