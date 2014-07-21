//
//  ContainerViewController.m
//  quinoa
//
//  Created by Hemen Chhatbar on 7/19/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()
@property(strong, nonatomic)  NSMutableArray    *viewControllers;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UIViewController *chatViewController;
@property (strong, nonatomic) UIView *fView;
@property (strong, nonatomic) UIViewController *dailySummaryViewController;
@property  BOOL isCollapsed;
@end

@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.viewControllers = [[NSMutableArray alloc] init];
        self.isCollapsed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.chatViewController = self.viewControllers[0];
    self.dailySummaryViewController = self.viewControllers[1];

    
    
    UIView *chatView = self.chatViewController.view;
    chatView.frame = self.contentView.frame;
    
    UIView *dailySummaryView = self.dailySummaryViewController.view;
    dailySummaryView.frame = CGRectMake(0, -430, self.contentView.frame.size.width, self.contentView.frame.size.height);
    //self.contentView.frame;
    
    
    
    //myViewController.view.frame = CGRectMake(0, 100, myViewController.view.frame.size.width, myViewController.view.frame.size.height);
    
    [self addChildViewController:self.dailySummaryViewController];
    
    [self.contentView addSubview: chatView];
    [self.contentView addSubview: dailySummaryView];
    
    [self.dailySummaryViewController didMoveToParentViewController:self];
    
    UIButton *but=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    but.frame= CGRectMake(300, 10, 10, 10);
    [but setTitle:@".........." forState:UIControlStateNormal];
    //[but addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [but addTarget:self action:@selector(expandDailySummary:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:but];


}




- (void) addViewController:(UIViewController *) vc {
    
    [self.viewControllers addObject:vc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)expandDailySummary:(id) sender {
    
    if(self.isCollapsed)
    {
    UIView *childView = self.dailySummaryViewController.view;
    
      [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        //if (velocity.x >= -10) {
        
        childView.frame = CGRectMake(0, -270, childView.frame.size.width, childView.frame.size.height);
        //}
    } completion:nil];
        self.isCollapsed = NO;
    }
    else{
       
        
        UIView *childView = self.dailySummaryViewController.view;
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //if (velocity.x >= -10) {
            
            childView.frame = CGRectMake(0, -430, childView.frame.size.width, childView.frame.size.height);
            //}
        } completion:nil];

        self.isCollapsed = YES;
        
    }
    
    
    
    
}


@end
