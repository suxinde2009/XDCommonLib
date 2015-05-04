//
//  XDDebug.h
//  XDCommonLib
//
//  Created by su xinde on 15/5/5.
//  Copyright (c) 2015年 su xinde. All rights reserved.
//

#ifndef XDCommonLib_XDDebug_h
#define XDCommonLib_XDDebug_h


/*
 * 说明 仅在debug模式下才显示nslog
 */
#if (1 == __XDDEBUG__)

    #undef	NSLogD
    #undef	NSLogDD
    #define NSLogD(fmt, ...) {NSLog((@"%s [Line %d] DEBUG: \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
    #define NSLogDD NSLogD(@"%@", @"");
    #define NSLogDSelf NSLogD(@"Class: %@", NSStringFromClass([self class]));

#else

    #define NSLogD(format, ...)
    #define NSLogDD
    #define NSLogDSelf

#endif






#endif
