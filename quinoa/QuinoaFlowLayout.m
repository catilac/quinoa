//
//  QuinoaFlowLayout.m
//  quinoa
//
//  Created by Chirag Davé on 8/3/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "QuinoaFlowLayout.h"

@implementation QuinoaFlowLayout

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    attributes.alpha = 0.0f;
    
    CGSize cellSize = attributes.frame.size;
    float multiplier = (itemIndexPath.row + 0.15f);
    attributes.center = CGPointMake(attributes.center.x -  multiplier * cellSize.width, attributes.center.y);
    return attributes;
}

@end
