//
//  XDCursorView.m
//  XDCommonLib
//
//  Created by SuXinDe on 2017/2/6.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import "XDCursorView.h"

@interface XDCursorView ()
{
    int _backgroundWidth;
}

@property (nonatomic, strong) UILabel *		indexType;

@end

@implementation XDCursorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)initView
{
    self.indexType = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, self.frame.size.width, 20)];
    self.indexType.font = [UIFont systemFontOfSize:15];
    self.indexType.textAlignment = NSTextAlignmentCenter;
    self.indexType.textColor = [UIColor whiteColor];
    self.indexType.text = self.title;
    [self addSubview:self.indexType];
    
    [self loadStstusLine];
    [self setImagView:0];
}

- (void)loadStstusLine
{
    _backgroundWidth = (self.frame.size.width - 10) / self.backgroundColors.count;
    
    for (int i = 0; i<self.backgroundColors.count; i++) {
        UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(5 + (i * _backgroundWidth), 70,_backgroundWidth, 2)];
        bgview.backgroundColor = self.backgroundColors[i];
        [self addSubview:bgview];
    }
    
    for (int i = 0; i<self.nameLabels.count; i++) {
        UILabel * labelName = [[UILabel alloc] initWithFrame:CGRectMake(5 + (i * _backgroundWidth) + _backgroundWidth / 2 - 20, 79, 42, 20)];
        
        labelName.text = self.nameLabels[i];
        labelName.textColor = self.backgroundColors[i];
        labelName.textAlignment = NSTextAlignmentCenter;
        labelName.font = [UIFont systemFontOfSize:12];
        [self addSubview:labelName];
    }
    
    for (int i = 0; i<self.backgroundColors.count - 1; i++) {
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake( 5 + _backgroundWidth + (i * _backgroundWidth), 65,2, 11)];
        lineView.backgroundColor = self.backgroundColors[i];
        [self addSubview:lineView];
        
        UILabel * labelNum = [[UILabel alloc] initWithFrame:CGRectMake(5 + _backgroundWidth + (i * _backgroundWidth) - 19,41, 42, 20)];
        labelNum.text = self.numberLabels[i];
        labelNum.textColor = self.backgroundColors[i];
        labelNum.textAlignment = NSTextAlignmentCenter;
        labelNum.font = [UIFont systemFontOfSize:11];
        [self addSubview:labelNum];
    }
}

- (void)setImagView:(NSInteger)index
{
    UIImage * image = [UIImage imageNamed:@"ico_location_red"];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(5 + (  index * _backgroundWidth ) + _backgroundWidth / 2 - 4 , 50, 9, 13);
    [self addSubview:imageView];
}


@end

