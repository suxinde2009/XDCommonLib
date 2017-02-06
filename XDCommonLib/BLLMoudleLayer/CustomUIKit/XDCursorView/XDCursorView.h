//
//  XDCursorView.h
//  XDCommonLib
//
//  Created by SuXinDe on 2017/2/6.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XDCursorView : UIView

@property (nonatomic, copy) NSString * title;

@property (nonatomic, strong) NSArray * backgroundColors;
@property (nonatomic, strong) NSArray * nameLabels;
@property (nonatomic, strong) NSArray * numberLabels;

- (void)initView;

@end
