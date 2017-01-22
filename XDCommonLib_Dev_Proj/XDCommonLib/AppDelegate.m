//
//  AppDelegate.m
//  XDCommonLib
//
//  Created by su xinde on 15/5/5.
//  Copyright (c) 2015年 su xinde. All rights reserved.
//

#import "AppDelegate.h"
#import "XDDebug.h"
#import "XDCommonLibMacros.h"

#import "XDFPSStatusUtils.h"

#import "XDClassMethodsTrackLog.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)testTodoMarco
{
//    @TODO("晚上要回家吃饭");
//    @TODO("晚上要早点睡");

    NSLog(@"是否是Retina屏幕: %d", XDIsRetina());
    
}


- (void)testRuntimeMethodsTrackLog
{
    //用法一
    /*
    [XDClassMethodsTrackLog logMethodWithClass:[UIViewController class] condition:^BOOL(SEL sel) {
        NSLog(@"method:%@", NSStringFromSelector(sel));
        return NO;
    } before:nil after:nil];
    */
    
    //用法二
    /*
    [XDClassMethodsTrackLog logMethodWithClass:[UIViewController class] condition:^BOOL(SEL sel) {
        
        NSArray *whiteList = @[@"loadView", @"viewDidLoad", @"viewWillAppear:", @"viewDidAppear:", @"viewWillDisappear:", @"viewDidDisappear:", @"viewWillLayoutSubviews", @"viewDidLayoutSubviews"];
        return [whiteList containsObject:NSStringFromSelector(sel)];
        
    } before:^(id target, SEL sel) {
        
        NSLog(@"before target:%@ sel:%@", target, NSStringFromSelector(sel));
        
    } after:^(id target, SEL sel) {
        
        NSLog(@"after target:%@ sel:%@", target, NSStringFromSelector(sel));
        
    }];
     */
    
    //用法三
    Class cls = NSClassFromString(@"ViewController");
    [XDClassMethodsTrackLog logMethodWithClass:cls condition:^BOOL(SEL sel) {
        
        return [NSStringFromSelector(sel) isEqualToString:@"viewDidLoad"];
        
    } before:^(id target, SEL sel) {
        
        NSLog(@"before frame%@", NSStringFromCGRect([(UIViewController *)target view].frame));
        
    } after:^(id target, SEL sel) {
        
        NSLog(@"after frame%@", NSStringFromCGRect([(UIViewController *)target view].frame));
        
    }];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 测试 runtime跟踪打印 各类的方法调用
    [self testRuntimeMethodsTrackLog];
    
    
    // 测试 TODO 宏定义
    [self testTodoMarco];
    
#if defined(DEBUG)||defined(_DEBUG)
    [[XDFPSStatusUtils sharedInstance] open];
#endif

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
