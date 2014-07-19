//
//  QuinoaTabBarViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/19/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "QuinoaTabBarViewController.h"
#import "TrackButton.h"

@interface QuinoaTabBarViewController ()

@end

@implementation QuinoaTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)popBackToLastTabBarView {
    NSLog(@"WHAT");
    [self setSelectedIndex:0];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popBackToLastTabBarView)
                                                 name:kCloseMenu
                                               object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
