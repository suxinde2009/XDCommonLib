//
//  UIViewController+Debugging.m
//  XDCommonLib
//
//  Created by suxinde on 2017/5/27.
//  Copyright © 2017年 su xinde. All rights reserved.
//

#import "UIViewController+Debugging.h"

@implementation UIViewController (Debugging)

- (void)showDebugger {
#ifdef DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id debugClass = NSClassFromString(@"UIDebuggingInformationOverlay");
    [debugClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
    
    id debugOverlayInstance = [debugClass performSelector:NSSelectorFromString(@"overlay")];
    [debugOverlayInstance performSelector:NSSelectorFromString(@"toggleVisibility")];
#pragma clang diagnostic pop
#endif
}

@end
