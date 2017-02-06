//
//  XDCollectionView.m
//  XDCommonLib
//
//  Created by suxinde on 2017/2/6.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import "XDCollectionView.h"

@interface XDCollectionView ()  <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<UICollectionViewDelegate> targetDelegate;

@end

@implementation XDCollectionView

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate
{
    self.targetDelegate = delegate;
    
    if (delegate) {
        if ([super respondsToSelector:@selector(setDelegate:)]) {
            [super setDelegate:self];
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector] || [self.targetDelegate respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    // 优先调用外部targetDelegate实现的方法
    if ([self.targetDelegate respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self.targetDelegate];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.allowsAutoScrollWhenSelected) {
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
        CGRect cellFrame = cell.frame;
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
        if (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            if (!CGRectEqualToRect(cellFrame, CGRectZero)) {
                if (CGRectGetMinX(cellFrame) - collectionView.contentOffset.x < CGRectGetWidth(cellFrame)) {
                    
                    NSInteger row = indexPath.item - 1;
                    if (row >= 0 && row < [self.dataSource collectionView:collectionView numberOfItemsInSection:indexPath.section]) {
                        [UIView animateWithDuration:.3 animations:^{
                            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]
                                         atScrollPosition:UICollectionViewScrollPositionNone
                                                 animated:NO];
                        }];
                    } else {
                        
                        NSInteger scrollSection = indexPath.section;
                        NSInteger scrollRow = indexPath.row;
                        if (row < 0) {
                            if (indexPath.section > 0) {
                                scrollSection = indexPath.section - 1;
                                scrollRow   = [self.dataSource collectionView:collectionView numberOfItemsInSection:scrollSection] - 1;
                            }
                        }
                        else if (row > [self.dataSource collectionView:collectionView numberOfItemsInSection:indexPath.section])
                        {
                            if (indexPath.section < [self.dataSource numberOfSectionsInCollectionView:collectionView]-1) {
                                scrollSection = indexPath.section + 1;
                                scrollRow = 0;
                            }
                        }
                        
                        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:scrollRow inSection:scrollSection];
                        
                        [UIView animateWithDuration:.3 animations:^{
                            [self scrollToItemAtIndexPath:scrollIndexPath
                                         atScrollPosition:UICollectionViewScrollPositionNone
                                                 animated:NO];
                        }];
                    }
                } else if (CGRectGetMinX(cellFrame) - self.contentOffset.x > (CGRectGetWidth(self.bounds) - 2 * CGRectGetWidth(cellFrame))) {
                    
                    NSInteger row = indexPath.item + 1;
                    if (row > 0 && row < [self.dataSource collectionView:self numberOfItemsInSection:indexPath.section]) {
                        
                        [UIView animateWithDuration:.3 animations:^{
                            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]
                                         atScrollPosition:UICollectionViewScrollPositionNone
                                                 animated:NO];
                        }];
                    }
                    else if ( row == [self.dataSource collectionView:self numberOfItemsInSection:indexPath.section] ) {
                        
                        // Bugfix:74516 特效切换时，无法自动推进到特效管理
                        if (indexPath.section + 1< [self numberOfSections]) {
                            
                            [UIView animateWithDuration:.3 animations:^{
                                [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section + 1]
                                             atScrollPosition:UICollectionViewScrollPositionNone
                                                     animated:NO];
                            }];
                        }
                    }
                    else {
                        [UIView animateWithDuration:.3 animations:^{
                            [self scrollToItemAtIndexPath:indexPath
                                         atScrollPosition:UICollectionViewScrollPositionNone
                                                 animated:NO];
                        }];
                    }
                }
            }
            else
            {
                
                [UIView animateWithDuration:.3 animations:^{
                    [self scrollToItemAtIndexPath:indexPath
                                 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                         animated:NO];
                }];
            }
        }
        else
        {
            if (!CGRectEqualToRect(cellFrame, CGRectZero)) {
                if (CGRectGetMinY(cellFrame) - collectionView.contentOffset.y < CGRectGetHeight(cellFrame)) {
                    
                    NSInteger row = indexPath.item - 1;
                    if (row >= 0 && row < [self.dataSource collectionView:collectionView numberOfItemsInSection:indexPath.section]) {
                        
                        [UIView animateWithDuration:.3 animations:^{
                            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]
                                         atScrollPosition:UICollectionViewScrollPositionNone
                                                 animated:NO];
                        }];
                    } else {
                        
                        NSInteger scrollSection = indexPath.section;
                        NSInteger scrollRow = indexPath.row;
                        if (row < 0) {
                            if (indexPath.section > 0) {
                                scrollSection = indexPath.section - 1;
                                scrollRow   = [self.dataSource collectionView:collectionView numberOfItemsInSection:scrollSection] - 1;
                            }
                        }
                        else if (row > [self.dataSource collectionView:collectionView numberOfItemsInSection:indexPath.section])
                        {
                            if (indexPath.section < [self.dataSource numberOfSectionsInCollectionView:collectionView]-1) {
                                scrollSection = indexPath.section + 1;
                                scrollRow = 0;
                            }
                        }
                        
                        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:scrollRow inSection:scrollSection];
                        
                        [UIView animateWithDuration:.3 animations:^{
                            [self scrollToItemAtIndexPath:scrollIndexPath
                                         atScrollPosition:UICollectionViewScrollPositionNone
                                                 animated:NO];
                        }];
                    }
                } else if (CGRectGetMinY(cellFrame) - self.contentOffset.y > (CGRectGetHeight(self.bounds) - 2 * CGRectGetHeight(cellFrame))) {
                    
                    NSInteger row = indexPath.item + 1;
                    if (row > 0 && row < [self.dataSource collectionView:self numberOfItemsInSection:indexPath.section]) {
                        [UIView animateWithDuration:.3 animations:^{
                            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]
                                         atScrollPosition:UICollectionViewScrollPositionNone
                                                 animated:NO];
                        }];
                    } else {
                        [UIView animateWithDuration:.3 animations:^{
                            [self scrollToItemAtIndexPath:indexPath
                                         atScrollPosition:UICollectionViewScrollPositionNone
                                                 animated:NO];
                        }];
                    }
                }
            }
            else
            {
                [UIView animateWithDuration:.3 animations:^{
                    [self scrollToItemAtIndexPath:indexPath
                                 atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                         animated:NO];
                }];
            }
        }
    }
    
    if ([self.targetDelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.targetDelegate collectionView:self didSelectItemAtIndexPath:indexPath];
    }
}


- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self collectionView:self didSelectItemAtIndexPath:indexPath];
    [self selectItemAtIndexPath:indexPath
                       animated:YES
                 scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

@end
