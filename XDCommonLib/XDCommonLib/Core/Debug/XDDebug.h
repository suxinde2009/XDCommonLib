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

// -----------------------------------------------------------
//
// TODO 宏定义
//
// http://blog.sunnyxx.com/2015/03/01/todo-macro/#rd
// https://github.com/sunnyxx/TodoMacro
//
// http://stackoverflow.com/questions/18252351/custom-preprocessor-macro-for-a-conditional-pragma-message-xxx
//
// -----------------------------------------------------------

// 转成字符串
#define STRINGIFY(S) #S
// 需要解两次才解开的宏
#define DEFER_STRINGIFY(S) STRINGIFY(S)

#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))

// 为warning增加更多信息
#define FORMATTED_MESSAGE(MSG) "[TODO-" DEFER_STRINGIFY(__COUNTER__) "] " MSG " \n" DEFER_STRINGIFY(__FILE__) " line " DEFER_STRINGIFY(__LINE__)

// 使宏前面可以加@
#define KEYWORDIFY try {} @catch (...) {}

// 最终使用的宏
#define TODO(MSG) KEYWORDIFY PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG))


// -----------------------------------------------------------


#endif
