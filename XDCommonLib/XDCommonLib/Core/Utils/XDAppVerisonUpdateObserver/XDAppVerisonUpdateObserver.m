//
//  XDAppVerObserver.m
//  XDCommonLib
//
//  Created by suxinde on 16/5/9.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import "XDAppVerisonUpdateObserver.h"

static NSString *const kXDAppVersionKey = @"kXDAppVersionKey";

@implementation XDAppVerisonUpdateObserver

+ (void)sycAppVerToCurrent
{
    NSString *curAppVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:curAppVer forKey:kXDAppVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isAppVersionChanged
{
    NSString *curAppVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *curAppVerInUserDefaults = [[NSUserDefaults standardUserDefaults] objectForKey:kXDAppVersionKey];
    return (![curAppVer isEqualToString:curAppVerInUserDefaults]);
}

@end
