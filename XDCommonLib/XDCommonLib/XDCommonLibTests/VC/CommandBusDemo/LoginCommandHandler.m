//
//  LoginCommandHandler.m
//  XDCommonLib
//
//  Created by suxinde on 16/5/11.
//  Copyright © 2016年 su xinde. All rights reserved.
//

#import "LoginCommandHandler.h"
#import "LoginCommand.h"

@implementation LoginCommandHandler

- (id)handle:(LoginCommand *)command {
    sleep(2);
    return [command.username stringByAppendingString:@" logged in"];
}

@end
