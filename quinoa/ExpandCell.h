//
//  ExpandCell.h
//  quinoa
//
//  Created by Amie Kweon on 7/6/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *planAttributes;
@property (nonatomic) BOOL isCompleted;

- (void)hideTableView:(BOOL)hide;
@end
