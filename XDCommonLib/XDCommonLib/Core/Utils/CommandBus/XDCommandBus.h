//
//  XDCommandBus.h
//  XDCommonLib
//
//  Created by suxinde on 16/5/11.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XDHandlerProtocol <NSObject>
@required
- (id)handle:(id)command;

@end


@interface XDCommandBus : NSObject

//execute a command object with its specific handler
- (id)executeCommand:(id)command;

//execute command with Completion Blocks
- (void)executeCommand:(id)command withCompletion:(void(^)(id result))completion;

@end
