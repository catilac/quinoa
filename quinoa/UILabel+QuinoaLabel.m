//
//  UILabel+QuinoaLabel.m
//  quinoa
//
//  Created by Amie Kweon on 7/13/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "UILabel+QuinoaLabel.h"
#import "Utils.h"

@implementation UILabel (QuinoaLabel)

-(void)awakeFromNib{
    float size = [self.font pointSize];
    self.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:size];
}

@end
