//
//  BoSectionBackgroundLayout.m
//  CollectionSectionView
//
//  Created by AlienJunX on 15/9/9.
//  Copyright (c) 2015年 com.alienjun.demo. All rights reserved.
//

#import "BoSectionBackgroundLayout.h"
#import "BoSectionBgReusableView.h"
//没有内容时默认高度
CGFloat defaultHeight = 98.0f;
NSString *decorationViewOfKind = @"decorationBgView";

@interface BoSectionBackgroundLayout()
@property (strong, nonatomic) NSMutableArray *itemAttributes;
@end

@implementation BoSectionBackgroundLayout
- (void)prepareLayout{
    [super prepareLayout];
    
    self.itemAttributes = [NSMutableArray new];
    NSInteger numberOfSection = self.collectionView.numberOfSections;
    for (int section=0; section<numberOfSection; section++){
        NSInteger lastIndex = [self.collectionView numberOfItemsInSection:section] - 1;
        
        CGRect frame = CGRectZero;
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewOfKind withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        attributes.zIndex = -1;
        if (lastIndex < 0) {
            frame = CGRectMake(0, 0, self.collectionView.frame.size.width, 36);
            if (section == 1) {
                UICollectionViewLayoutAttributes *headerView = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
                attributes.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame), self.collectionView.frame.size.width, defaultHeight);
            }
        }else{
            UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:lastIndex inSection:section]];
            
            frame = CGRectUnion(firstItem.frame, lastItem.frame);
            frame.origin.x -= self.sectionInset.left;
            frame.origin.y -= self.sectionInset.top;
            frame.size.width = self.collectionView.frame.size.width;
            frame.size.height += self.sectionInset.top + self.sectionInset.bottom;
            if (section == 1) {
                //保持默认高度
                frame.size.height = frame.size.height < defaultHeight? defaultHeight:frame.size.height;
            }
        }
        
        attributes.frame = frame;
        [self.itemAttributes addObject:attributes];
        [self registerClass:[BoSectionBgReusableView class] forDecorationViewOfKind:@"decorationBgView"];
        
    }
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    for (UICollectionViewLayoutAttributes *attribute in self.itemAttributes){
        if (!CGRectIntersectsRect(rect, attribute.frame))
            continue;
        
        [attributes addObject:attribute];
    }
    
    return attributes;
}
@end
