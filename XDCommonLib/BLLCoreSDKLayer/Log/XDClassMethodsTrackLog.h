//
//  XDClassMethodsTrackLog.h
//  XDCommonLib
//
//  Created by suxinde on 2017/1/22.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 思路是这样的:
 1.通过class_copyMethodList得出一个类的所有方法。
 2.通过method_getTypeEncoding和method_copyReturnType得出方法的参数类型和返回值。
 3.创建出SEL和IMP，通过class_addMethod动态添加新方法。
 4.通过交换的思想，在新方法里通过NSInvocation来调用原方法。
 
 难点在于，新方法里面怎么把方法的“实现”(即IMP)绑定上，并且在“实现”里调用原方法。在runtime的头文件中Method的结构：
 
 typedef struct objc_method *Method;
 
 struct objc_method {
 SEL method_name
 char *method_types
 IMP method_imp
 }
 
 可以看到Method包含了是三个元素：一个SEL，一个char *，一个IMP。
 SEL是方法名，char *是方法的类型，IMP就是实现的地址。
 */


/**
 利用runtime追踪对象的每一个方法
 http://blog.csdn.net/haoxinqingb/article/details/54613806
 */
@interface XDClassMethodsTrackLog : NSObject

+ (void)logMethodWithClass:(Class)aClass
                 condition:(BOOL(^)(SEL sel))condition
                    before:(void(^)(id target, SEL sel))before
                     after:(void(^)(id target, SEL sel))after;

@end
