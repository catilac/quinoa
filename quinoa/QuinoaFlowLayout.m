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
    attributes.alpha = 0.0;
    
    CGSize size = [self collectionView].frame.size;
    attributes.center = CGPointMake(size.width / 2.0, size.height / 2.0);
    return attributes;}

@end
