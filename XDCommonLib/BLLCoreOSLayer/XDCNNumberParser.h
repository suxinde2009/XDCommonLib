//
//  XDCNNumberParser.h
//  XDCommonLib
//
//  Created by suxinde on 2017/1/5.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 改自于 CNNumberParser， 用于将·阿拉伯数字·转换为·汉字·数字表示
 */
@interface XDCNNumberParser : NSObject

+ (NSString *)cn_numberWithInteger:(NSInteger)integer;

@end

@interface XDCNNumberParser (UnitTest)

+ (void)unitTest;

@end
