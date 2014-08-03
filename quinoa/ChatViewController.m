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
#import "ProfileViewSimple.h"
#import "ExpertBrowserViewController.h"

@interface ChatViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *chatView;
@property (weak, nonatomic) IBOutlet UITextField *chatInput;
@property (weak, nonatomic) IBOutlet UIView *inputContainer;

@property (strong, nonatomic) User *recipient;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSTimer *queryTimer;

@property (strong, nonatomic) ChatCell *stubCell;
@property (strong, nonatomic) ProfileViewSimple *profileHeader;

@property (assign) Boolean keyboardOut;
@property (assign) CGSize kbSize;
@property (assign) Boolean headerOut;

- (void)willShowKeyboard:(NSNotification *)notification;
- (void)willHideKeyboard:(NSNotification *)notification;
- (IBAction)onViewTap:(UITapGestureRecognizer *)sender;

@end

@implementation ChatViewController

static NSString *CellIdentifier = @"chatCellIdent";

- (id)initWithUser:(User *)recipient {
    self = [super init];
    if (self) {
        
        
            UIBarButtonItem *browse = [[UIBarButtonItem alloc] initWithTitle:@"Browse"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(showExpertsBrowser)];
            self.navigationItem.rightBarButtonItem = browse;
      

        self.recipient = recipient;
        [self.recipient fetchInBackgroundWithBlock:nil];
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

- (void)showExpertsBrowser {

        ExpertBrowserViewController *expertBrowser = [[ExpertBrowserViewController alloc] initIsModal:YES];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:expertBrowser];
        [self presentViewController:nc animated:YES completion:^{
            NSLog(@"Presenting Expert Browser");
        }];
    
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
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 10, 10)];
    
    [self.chatView setCollectionViewLayout:flowLayout];
    
    self.queryTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(fetchMessages)
                                   userInfo:nil
                                    repeats:YES];
    
    self.profileHeader = [[ProfileViewSimple alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    self.profileHeader.backgroundColor = [Utils getDarkBlue];
    self.profileHeader.alpha = 1;
    [self.profileHeader setUser:self.recipient];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    [self.view addSubview:self.profileHeader];
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
    
    [self scrollToBottom];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint scrollVelocity = [self.chatView.panGestureRecognizer velocityInView:self.chatView.superview];
    
    //NSLog(@"%f", scrollVelocity.y);
    if (scrollVelocity.y > 1000.0f) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.profileHeader.alpha = 1;
            [self.profileHeader setTransform:CGAffineTransformMakeTranslation(0.0, 0.0)];
        } completion:nil];
    }
    else if (scrollVelocity.y < -1000.0f) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.profileHeader.alpha = 0.0;
            [self.profileHeader setTransform:CGAffineTransformMakeTranslation(0.0, -20.0)];
        } completion:nil];
    }
    
}


- (IBAction)onSend:(id)sender {
    
    [Message sendMessageToUser:self.recipient
                      fromUser:[User currentUser]
                       message:self.chatInput.text];
    self.chatInput.text = @"";
    
}

- (void)fetchMessages {
    // Reset the other user's message count since i'm reading it here;
    // this is causing an issue because it's trying to save unlogged in user.
    //[self.recipient resetNewMessageCount];
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
                                   //[self scrollToBottom];
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
