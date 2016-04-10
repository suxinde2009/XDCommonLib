//
//  NSThread+Utils.h
//  XDCommonLib
//
//  Created by su xinde on 15/11/18.
//  Copyright © 2015年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Runs a block in the main thread
 *
 *  @param ^block Block to be executed
 */
NS_INLINE void XDRunOnMainThread(void  (^ _Nonnull block)(void)) {
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

@interface NSThread (Utils)

@end
