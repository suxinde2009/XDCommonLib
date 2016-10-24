//
//  XDGCDThrottle.h
//  XDCommonLib
//
//  Created by suxinde on 2016/10/24.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import <UIKit/UIKit.h>

#define THROTTLE_MAIN_QUEUE (dispatch_get_main_queue())
#define THROTTLE_GLOBAL_QUEUE (dispatch_get_global_queue(0,0))

typedef void (^XDGCDThrottleBlock)();

@interface XDGCDThrottle : NSObject


void dispatch_throttle(NSTimeInterval threshold,
                       XDGCDThrottleBlock block);

void dispatch_throttle_on_queue(NSTimeInterval threshold,
                                dispatch_queue_t queue,
                                XDGCDThrottleBlock block);

+ (void)throttle:(NSTimeInterval)threshold
           block:(XDGCDThrottleBlock)block;

+ (void)throttle:(NSTimeInterval)threshold
           queue:(dispatch_queue_t)queue
           block:(XDGCDThrottleBlock)block;

@end
