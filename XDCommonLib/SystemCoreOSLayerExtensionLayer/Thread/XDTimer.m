//
//  XDTimer.m
//  XDCommonLib
//
//  Created by suxinde on 2017/6/15.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import "XDTimer.h"
#import <pthread.h>

@interface XDTimer () {
    BOOL _valid;
    NSTimeInterval _timeInterval;
    BOOL _repeats;
    __weak id _target;
    SEL _selector;
    
    dispatch_source_t _source;
    dispatch_semaphore_t _lock;
}
@end

@implementation XDTimer

- (instancetype)initWithFireTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                          target:(id)target
                        selector:(SEL)selector
                         repeats:(BOOL)repeats {
    self = [super init];
    _repeats = repeats;
    _timeInterval = interval;
    _valid = YES;
    _target = target;
    _selector = selector;
    
    __weak typeof(self) _self = self;
    _lock = dispatch_semaphore_create(1);
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_source, dispatch_time(DISPATCH_TIME_NOW, (start * NSEC_PER_SEC)), (interval * NSEC_PER_SEC), 0);
    dispatch_source_set_event_handler(_source, ^{[_self fire];});
    dispatch_resume(_source);
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"XDTimer init error" reason:@"Use the designated initializer to init." userInfo:nil];
    return [self initWithFireTime:0
                         interval:0
                           target:self
                         selector:@selector(invalidate)
                          repeats:NO];
}

+ (XDTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                            target:(id)target
                          selector:(SEL)selector
                           repeats:(BOOL)repeats {
    return [[self alloc] initWithFireTime:interval
                                 interval:interval
                                   target:target
                                 selector:selector
                                  repeats:repeats];
}

- (void)invalidate {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    if (_valid) {
        dispatch_source_cancel(_source);
        _source = NULL;
        _target = nil;
        _valid = NO;
    }
    dispatch_semaphore_signal(_lock);
}

- (void)fire {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    id target = _target;
    if (!_repeats || !target) {
        dispatch_semaphore_signal(_lock);
        [self invalidate];
    } else {
        dispatch_semaphore_signal(_lock);
        [target performSelector:_selector withObject:self];
    }
#pragma clang diagnostic pop
}

- (BOOL)repeats {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    BOOL repeats = _repeats;
    dispatch_semaphore_signal(_lock);
    return repeats;
}

- (NSTimeInterval)timeInterval {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSTimeInterval timeInterval = _timeInterval;
    dispatch_semaphore_signal(_lock);
    return timeInterval;
}

- (BOOL)isValid {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    BOOL isValid = _valid;
    dispatch_semaphore_signal(_lock);
    return isValid;
}

- (void)dealloc {
    [self invalidate];
}

@end
