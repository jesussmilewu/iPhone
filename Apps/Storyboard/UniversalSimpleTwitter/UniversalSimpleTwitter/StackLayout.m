//
//  StackLayout.m
//  UniversalSimpleTwitter
//
//  Created by Clemens Wagner on 21.07.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import "StackLayout.h"

@implementation NSMutableArray(StackLayout)

- (void)addLayoutAttributes:(UICollectionViewLayoutAttributes *)inAttributes intersectingRect:(CGRect)inRect {
    if(CGRectIntersectsRect(inRect, inAttributes.frame)) {
        [self addObject:inAttributes];
    }
}

@end
@implementation StackLayout

@synthesize selectedIndexPath;

- (CGSize)collectionViewContentSize {
    return self.collectionView.bounds.size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)inBounds {
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)inIndexPath {
    UICollectionViewLayoutAttributes *theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:inIndexPath];
    UICollectionView *theView = self.collectionView;
    CGSize theSize = self.collectionViewContentSize;
    CGFloat theRadius = fminf(theSize.width, theSize.height);
    id theDelegate = theView.delegate;
    float theCount = (float) [theView numberOfItemsInSection:inIndexPath.section];
    float theScale = (float) inIndexPath.row / theCount;
    float theAngle = 4 * M_PI * theScale;
    CGPoint theCenter = CGPointMake(theSize.width / 2.0, theSize.height / 2.0);
    
    if([theDelegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        theAttributes.size = [theDelegate collectionView:theView layout:self sizeForItemAtIndexPath:inIndexPath];
    }
    theScale = sqrt(theScale) * 3.0 / 13.0;
    theAttributes.center = CGPointMake(theCenter.x + cos(theAngle) * theRadius * theScale,
                                       theCenter.y + sin(theAngle) * theRadius * theScale);
    theAttributes.zIndex = [self.selectedIndexPath isEqual:inIndexPath] ? 1 : -inIndexPath.row;
    theAttributes.transform3D = CATransform3DMakeRotation(-theAngle / (theCount + 1), 0.0, 0.0, 1.0);
    return theAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)inKind
                                                                     atIndexPath:(NSIndexPath *)inIndexPath {
    UICollectionViewLayoutAttributes *theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:inKind withIndexPath:inIndexPath];
    CGSize theSize = [self collectionViewContentSize];
    
    if([UICollectionElementKindSectionHeader isEqualToString:inKind]) {
        theAttributes.frame = CGRectMake(0.0, 0.0, theSize.width, 44.0);
    }
    else if([UICollectionElementKindSectionFooter isEqualToString:inKind]) {
        theAttributes.frame = CGRectMake(0.0, theSize.height - 44.0, theSize.width, 44.0);
    }
    return theAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)inKind atIndexPath:(NSIndexPath *)inIndexPath {
    UICollectionViewLayoutAttributes *theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:inKind withIndexPath:inIndexPath];
    
    theAttributes.size = CGSizeMake(70.0, 70.0);
    theAttributes.center = CGPointMake(70.0, 114.0);
    return theAttributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)inRect {
    NSInteger theSectionCount = [self.collectionView numberOfSections];
    NSMutableArray *theArray = [NSMutableArray array];
    UICollectionViewLayoutAttributes *theAttributes;
    
    for(NSInteger i = 0; i < theSectionCount; ++i) {
        NSInteger theCount = [self.collectionView numberOfItemsInSection:i];
        
        theAttributes = [self layoutAttributesForDecorationViewOfKind:@"Logo" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        [theArray addLayoutAttributes:theAttributes intersectingRect:inRect];
        theAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        [theArray addLayoutAttributes:theAttributes intersectingRect:inRect];
        for(NSInteger j = 0; j < theCount; ++j) {
            NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
            
            theAttributes = [self layoutAttributesForItemAtIndexPath:theIndexPath];
            [theArray addLayoutAttributes:theAttributes intersectingRect:inRect];
        }
        theAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:1 inSection:i]];
        [theArray addLayoutAttributes:theAttributes intersectingRect:inRect];
    }
    return theArray;
}

@end
