//
//  NSProcessInfo+XDCommonLib.h
//  XDCommonLib
//
//  Created by suxinde on 16/4/11.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSProcessInfo (XDCommonLib)

/**
 *  Returns the CPU usage
 *
 *  @return Returns the CPU usage
 */
+ (float)cpuUsage DEPRECATED_MSG_ATTRIBUTE("Use +currentAppCPUUsage");

/**
 *  Returns the CPU usage by the current App
 *
 *  @return Returns the CPU usage by the current App
 */
+ (float)currentAppCPUUsage;


@end
