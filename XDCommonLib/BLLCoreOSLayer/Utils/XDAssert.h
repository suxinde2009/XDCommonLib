//
//  XDAssert.h
//  XDCommonLib
//
//  Created by SuXinDe on 2018/2/27.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XDLogBug NSLog // Use DDLogError if you’re using Lumberjack

// XDAssert and XDCAssert work exactly like NSAssert and NSCAssert
// except they log, even in release mode

#define XDAssert(condition, desc, ...) \
if (!(condition)) { \
    XDLogBug((desc), ## __VA_ARGS__); \
    NSAssert((condition), (desc), ## __VA_ARGS__); \
}

#define XDCAssert(condition, desc) \
if (!(condition)) { \
    XDLogBug((desc), ## __VA_ARGS__); \
    NSCAssert((condition), (desc), ## __VA_ARGS__); \
}
