//
//  NSObject+DeallocHandler.h
//  XDCommonLib
//
//  Created by suxinde on 2016/10/24.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DeallocHandler)

/**
 @brief 添加一个block,当该对象释放时被调用
 **/
- (void)guard_addDeallocBlock:(void(^)(void))block;


@end
