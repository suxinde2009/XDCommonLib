//
//  XDCollectionView.h
//  XDCommonLib
//
//  Created by suxinde on 2017/2/6.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDCollectionView : UICollectionView

@property (nonatomic, assign) BOOL allowsAutoScrollWhenSelected;

@property (nonatomic, copy) NSString *title;

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
