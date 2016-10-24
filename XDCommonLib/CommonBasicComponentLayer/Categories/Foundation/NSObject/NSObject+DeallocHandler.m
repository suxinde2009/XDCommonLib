//
//  NSObject+DeallocHandler.m
//  XDCommonLib
//
//  Created by suxinde on 2016/10/24.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import "NSObject+DeallocHandler.h"
#import <objc/runtime.h>

/*
 为对象添加一个释放时触发的block
 http://www.tanhao.me/pieces/160626.html/
 
 有时我们需要在一个对象生命周期结束的时候触发一个操作,希望当该对象dealloc的时候调用一个外部指定的block,
 但又不希望直接hook dealloc方法,这样侵入性太强了.下面贴一段非常简单的实现方式,通过一个category给外部
 暴露一个block注入的接口,内部将该block封装到一个寄生对象中(Parasite),该寄生对象在dealoc的时候触发
 block调用,所有的寄生对象通过runtime的AssociatedObject机制与宿主共存亡,从而达到监控宿主生命周期的目的.
 
 注意事项
 
 block触发的线程与对象释放时的线程一致,请注意后续操作的线程安全.
 不要在block中强引用对象,否则引用循环释放不了;
 不要在block中通过weak引用对象,因为此时会返回nil;
 (根据WWDC2011,Session322对对象释放时间的描述，associated objects清除在对象生命周期中很晚才执行，
 通过被NSObject -dealloc方法调用的object_dispose()函数完成);
 */


@interface XDObjectDeallocHandleBlockParasite : NSObject
@property (nonatomic, copy) void(^deallocBlock)(void);
@end

@implementation XDObjectDeallocHandleBlockParasite

- (void)dealloc {
    if (self.deallocBlock) {
        self.deallocBlock();
    }
}

@end

@implementation NSObject (DeallocHandler)

- (void)guard_addDeallocBlock:(void(^)(void))block
{
    @synchronized (self) {
        static NSString *kAssociatedKey = nil;
        NSMutableArray *parasiteList = objc_getAssociatedObject(self, &kAssociatedKey);
        if (!parasiteList) {
            parasiteList = [NSMutableArray new];
            objc_setAssociatedObject(self, &kAssociatedKey, parasiteList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        XDObjectDeallocHandleBlockParasite *parasite = [XDObjectDeallocHandleBlockParasite new];
        parasite.deallocBlock = block;
        [parasiteList addObject: parasite];
    }
}

@end
