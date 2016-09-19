//
//  XDFreePortAllocator.h
//  XDCommonLib
//
//  Created by suxinde on 16/9/19.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  Allocates and returns a free TCP Port
 */
@interface XDFreePortAllocator : NSObject

/**
 *  The last TCP Port allocated.
 *  Will default to 0 if no port has been successfully allocated.
 */
@property (nonatomic, assign, readonly) NSInteger lastPort;

/**
 *  Use this method to get a singleton for this class.
 *  Might come in handy if you need to use the TCP Port at different places.
 *
 *  @return A Singleton of this class
 */
+ (instancetype)sharedInstance;

/**
 *  Performs a new TCP Port allocation
 *
 *  @param error An NSError Object if no TCP Port could be allocated.
 *
 *  @return An NSInteger containing the free allocated TCP Port
 */
- (NSInteger)allocatePort:(NSError **)error;

@end
