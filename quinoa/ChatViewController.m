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
@property (strong, nonatomic) NSArray *messages;
@property (strong, nonatomic) NSTimer *queryTimer;

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

- (void)viewDidLayoutSubviews {
    
    if (self.chatView.contentSize.height > self.chatView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.chatView.contentSize.height - self.chatView.frame.size.height);
        [self.chatView setContentOffset:offset animated:YES];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
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

- (void)willShowKeyboard:(NSNotification *)notification {
    
    NSLog(@"willShowKeyboard: %f", self.inputContainer.frame.origin.y);
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the keyboard height and width from the notification
    // Size varies depending on OS, language, orientation
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
    
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
                         self.inputContainer.frame = CGRectMake(self.inputContainer.frame.origin.x, self.inputContainer.frame.origin.y - kbSize.height + self.tabBarController.tabBar.frame.size.height, self.inputContainer.frame.size.width, self.inputContainer.frame.size.height);
                         
                         self.chatView.frame = CGRectMake(self.chatView.frame.origin.x, self.chatView.frame.origin.y - kbSize.height + self.tabBarController.tabBar.frame.size.height, self.chatView.frame.size.width, self.chatView.frame.size.height);
                     }
                     completion:nil];
}


- (void)willHideKeyboard:(NSNotification *)notification {
    
    NSLog(@"willHideKeyboard: %f", self.inputContainer.frame.origin.y);
    
    NSDictionary *userInfo = [notification userInfo];
    
    //CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    
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
                         self.inputContainer.frame = CGRectMake(self.inputContainer.frame.origin.x, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - self.inputContainer.frame.size.height + self.navigationController.navigationBar.frame.size.height + 5, self.inputContainer.frame.size.width, self.inputContainer.frame.size.height);
                         
                         self.chatView.frame = CGRectMake(self.chatView.frame.origin.x, 0, self.chatView.frame.size.width, self.chatView.frame.size.height);
                         
                     }
                     completion:nil];
}

- (IBAction)onViewTap:(UITapGestureRecognizer *)sender {
    
    // get touch location
    CGPoint touchPosition = [sender locationInView:self.view];
    
    if(touchPosition.y < self.inputContainer.frame.origin.y) {
        
        NSLog(@"Dismiss keyboard");
        // dismiss keyboard
        [self.view endEditing:YES];
    }
    
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
    
    //cell.layer.borderWidth = 1;
    //cell.layer.borderColor = [Utils getGray].CGColor;
    cell.layer.cornerRadius = 6;
    
    Message *message = self.messages[indexPath.row];
    [cell updateChatCellWithMessage:message];
    return cell;
}


@end
